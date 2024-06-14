// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';

class Downloader {
  static void myNotificationTapCallback(
      Task task, NotificationType notificationType) {
    debugPrint(
        '[FileDownloader] Tapped notification $notificationType for taskId ${task.taskId}');
  }

  static void initialize() {
    if (kIsWeb) return;

    FileDownloader()
        .registerCallbacks(
            taskNotificationTapCallback: myNotificationTapCallback)
        .configureNotificationForGroup(
          FileDownloader.defaultGroup,
          // For the main download button
          // which uses 'enqueue' and a default group
          running:
              const TaskNotification('Download {filename}', 'Downloading…'),
          complete: const TaskNotification(
              'Download {filename}', 'Download completed'),
          error:
              const TaskNotification('Download {filename}', 'Download failed'),
          paused:
              const TaskNotification('Download {filename}', 'Download paused'),
          progressBar: true,
        )
        .configureNotificationForGroup(
          'bunch',
          running: const TaskNotification(
              '{numFinished} out of {numTotal}', 'Progress = {progress}'),
          complete: const TaskNotification("Done!", "Loaded {numTotal} files"),
          error:
              const TaskNotification('Error', '{numFailed}/{numTotal} failed'),
          progressBar: false,
          groupNotificationId: 'notGroup',
        )
        .configureNotification(
          // for the 'Download & Open' dog picture
          // which uses 'download' which is not the .defaultGroup
          // but the .await group so won't use the above config
          complete: const TaskNotification(
              'Download {filename}', 'Download completed'),
          tapOpensFile: true,
        ); // dog can also open directly from tap
  }
}
