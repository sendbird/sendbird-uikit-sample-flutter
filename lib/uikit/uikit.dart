// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/notifications/push_manager.dart';
import 'package:sendbird_uikit_sample/utils/app_prefs.dart';

class UIKit {
  UIKit._();

  static final UIKit _uikit = UIKit._();

  factory UIKit() => _uikit;

  DownloadTask? backgroundDownloadTask;
  StreamSubscription<TaskUpdate>? downloadSubscription;

  static String currentAppId = '';
  static String currentUserId = '';
  static String currentNickname = '';

  static Widget provider({required Widget child}) {
    return SendbirdUIKit.provider(child: child);
  }

  static String getVersion() {
    return SendbirdUIKit.version;
  }

  static Future<bool> logout() async {
    SendbirdChat.removeAllConnectionHandlers();
    return await SendbirdUIKit.disconnect();
  }

  static bool isInitialized() {
    return SendbirdUIKit.isInitialized();
  }

  static Future<bool> login(
      String appId, String userId, String nickname) async {
    currentAppId = appId;
    currentUserId = userId;
    currentNickname = nickname;

    if (appId.isEmpty || userId.isEmpty) {
      return false;
    }

    if (nickname.isEmpty) {
      nickname = userId;
    }

    final isGranted = await PushManager.requestPermission();
    if (isGranted) {
      if (await initSendbirdUIKit(appId: appId)) {
        if (await SendbirdUIKit.connect(userId, nickname: nickname)) {
          await connected(currentAppId, currentUserId, currentNickname);
          return true;
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: 'The permission was not granted regarding push notifications.',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
    }
    return false;
  }

  static Future<bool> initSendbirdUIKit({String? appId}) async {
    if (appId == null) {
      await AppPrefs().initialize();
      appId = AppPrefs().getAppId();
    }

    return await SendbirdUIKit.init(
      appId: appId,
      options: SendbirdChatOptions()..useAutoResend = true,
      navigatorKey: Get.key,
      addCloseButtonInDelayedConnectingDialog: false,
      takePhoto: kIsWeb
          ? null
          : () async {
              final photo =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (photo?.path != null) {
                return FileInfo.fromFile(
                  file: File(photo!.path),
                  fileName: photo.name,
                  mimeType: 'image/*',
                );
              }
              return null;
            },
      takeVideo: kIsWeb
          ? null
          : () async {
              final photo =
                  await ImagePicker().pickVideo(source: ImageSource.camera);
              if (photo?.path != null) {
                return FileInfo.fromFile(
                  file: File(photo!.path),
                  fileName: photo.name,
                  mimeType: 'video/*',
                );
              }
              return null;
            },
      choosePhoto: () async {
        return await _chooseFile(fileType: FileType.image);
      },
      chooseMedia: () async {
        return await _chooseFile(fileType: FileType.media);
      },
      chooseDocument: () async {
        return await _chooseFile(fileType: FileType.any);
      },
      chooseFiles: () async {
        return await _chooseFiles(fileType: FileType.any);
      },
      downloadFile: kIsWeb
          ? null
          : (fileUrl, fileName, downloadCompleted) async {
              await _downloadFile(fileUrl, fileName, downloadCompleted);
            },
    );
  }

  static Future<FileInfo?> _chooseFile({required FileType fileType}) async {
    try {
      if (!(await _checkPermissions())) {
        return null;
      }

      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowMultiple: false,
        compressionQuality: 0, // for Android 10
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (kIsWeb) {
          if (file.bytes != null) {
            return FileInfo(
              fileBytes: file.bytes,
              fileName: file.name,
            );
          }
        } else {
          if (file.path != null) {
            return FileInfo(
              file: File(file.path!),
              fileName: file.name,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('[FilePicker][Error] ${e.toString()}');
    }
    return null;
  }

  static Future<List<FileInfo>> _chooseFiles({
    required FileType fileType,
  }) async {
    List<FileInfo> fileInfoList = [];

    try {
      if (!(await _checkPermissions())) {
        return [];
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
        compressionQuality: 0, // for Android 10
      );

      if (result != null && result.files.isNotEmpty) {
        // Sort files by name on web to ensure consistent ordering
        final files = kIsWeb
            ? (result.files.toList()..sort((a, b) => a.name.compareTo(b.name)))
            : result.files;

        for (PlatformFile file in files) {
          if (kIsWeb) {
            if (file.bytes != null) {
              fileInfoList.add(FileInfo(
                fileBytes: file.bytes,
                fileName: file.name,
              ));
            }
          } else {
            if (file.path != null) {
              fileInfoList.add(FileInfo(
                file: File(file.path!),
                fileName: file.name,
              ));
            }
          }
        }
      }
      return fileInfoList;
    } catch (e) {
      debugPrint('[FilePicker][Error] ${e.toString()}');
    }
    return fileInfoList;
  }

  static Future<bool> _checkPermissions() async {
    if (kIsWeb) {
      return true;
    }

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      // 33 = Android 13 (Tiramisu)
      if (androidInfo.version.sdkInt < 33) {
        // Fallback for Android versions below 13
        await _getPermission(PermissionType.androidSharedStorage);
      } else {
        final isGranted = await ph.Permission.camera.status.isGranted ||
            await ph.Permission.photos.status.isGranted &&
                await ph.Permission.videos.status.isGranted;
        if (!isGranted) {
          Map<ph.Permission, ph.PermissionStatus> statuses = await [
            ph.Permission.camera,
            ph.Permission.photos,
            ph.Permission.videos,
          ].request();

          if (statuses[ph.Permission.camera] != ph.PermissionStatus.granted ||
              statuses[ph.Permission.photos] != ph.PermissionStatus.granted ||
              statuses[ph.Permission.videos] != ph.PermissionStatus.granted) {
            if (statuses[ph.Permission.camera] ==
                    ph.PermissionStatus.permanentlyDenied ||
                statuses[ph.Permission.photos] ==
                    ph.PermissionStatus.permanentlyDenied ||
                statuses[ph.Permission.videos] ==
                    ph.PermissionStatus.permanentlyDenied) {
              // Open app settings for user to manually grant permission
              await ph.openAppSettings();
            }
            return false;
          }
        }
      }
    } else if (Platform.isIOS) {
      // Check and request iOS photo library permissions
      ph.PermissionStatus status = await ph.Permission.photos.status;
      if (status.isDenied ||
          status.isRestricted ||
          status.isPermanentlyDenied) {
        status = await ph.Permission.photos.request();
        if (status.isDenied ||
            status.isRestricted ||
            status.isPermanentlyDenied) {
          debugPrint('[FilePicker] Photo library permission denied');
          if (status.isPermanentlyDenied) {
            // Open app settings for user to manually grant permission
            await ph.openAppSettings();
          }
          return false;
        }
      } else if (status.isLimited) {
        // iOS 14+ limited photos access - user selected specific photos
        debugPrint('[FilePicker] Limited photo library access granted');
      }
    }
    return true;
  }

  static Future<void> _downloadFile(
    String fileUrl,
    String? fileName,
    void Function() downloadCompleted,
  ) async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        await _getPermission(PermissionType.androidSharedStorage);
      }
      await _getPermission(PermissionType.notifications);

      String? newFileName = fileName;
      String? directory;

      if (Platform.isAndroid) {
        directory = '/storage/emulated/0/Download';
      } else {
        directory = (await getApplicationDocumentsDirectory()).path;
      }

      if (fileName != null && fileName.isNotEmpty) {
        bool isExists = false;
        int number = 2;
        final ext = _getFileExtension(fileName);
        final name = fileName.substring(0, fileName.length - ext.length);

        do {
          final filePath = '$directory/$newFileName';
          isExists = await File(filePath).exists();
          if (isExists) {
            newFileName = '$name ($number)$ext';
            number++;
          }
        } while (isExists);
      }

      _uikit.backgroundDownloadTask = DownloadTask(
        url: fileUrl,
        filename: newFileName,
        baseDirectory: BaseDirectory.root,
        directory: directory,
        updates: Updates.statusAndProgress,
        retries: 3,
        allowPause: true,
      );

      debugPrint(
          '[FileDownloader][filePath()] ${await _uikit.backgroundDownloadTask?.filePath()}');

      _uikit.downloadSubscription ??= FileDownloader().updates.listen((update) {
        switch (update) {
          case TaskStatusUpdate():
            debugPrint('[FileDownloader][Status] ${update.status}');
            if (update.status == TaskStatus.complete) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                downloadCompleted();
              });
            }
            break;

          case TaskProgressUpdate():
            debugPrint('[FileDownloader][Progress] ${update.progress}');
            break;
        }
      });

      await FileDownloader().enqueue(_uikit.backgroundDownloadTask!);
    } catch (e) {
      debugPrint('[FileDownloader][Error] ${e.toString()}');
    }
  }

  static String _getFileExtension(String fileName) {
    try {
      return '.${fileName.split('.').last}';
    } catch (_) {
      return '';
    }
  }

  static Future<void> _getPermission(PermissionType permissionType) async {
    var status = await FileDownloader().permissions.status(permissionType);
    if (status != PermissionStatus.granted) {
      if (await FileDownloader()
          .permissions
          .shouldShowRationale(permissionType)) {
        debugPrint('[FileDownloader] Showing some rationale');
      }
      status = await FileDownloader().permissions.request(permissionType);
      debugPrint('[FileDownloader] Permission for $permissionType was $status');
    }
  }

  static Future<void> connected(
      String appId, String userId, String nickname) async {
    await AppPrefs().setAppId(appId);
    await AppPrefs().setUserId(userId);
    await AppPrefs().setNickname(nickname);

    if (SendbirdChat.getPendingPushToken() != null) {
      await PushManager.registerPushToken();
    }

    if ((await PushManager.checkPushNotification()) == false) {
      if (Get.currentRoute.startsWith('/waiting_for_connection')) {
        Get.back();
      }
      if (Get.currentRoute.startsWith('/basic_sample_login')) {
        Get.offAllNamed('/basic_sample');
      }
    }
  }
}
