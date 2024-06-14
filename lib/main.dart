// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sendbird_uikit_sample/notifications/local_notifications_manager.dart';
import 'package:sendbird_uikit_sample/notifications/push_manager.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/basic_sample_login_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/basic_sample_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/group_channel_create_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/group_channel_list_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/group_channel_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/information/group_channel_information_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/information/group_channel_members_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/information/moderation/group_channel_banned_users_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/information/moderation/group_channel_moderations_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/information/moderation/group_channel_muted_members_page.dart';
import 'package:sendbird_uikit_sample/page/basic_sample/group_channel/information/moderation/group_channel_operators_page.dart';
import 'package:sendbird_uikit_sample/page/home_page.dart';
import 'package:sendbird_uikit_sample/uikit/uikit.dart';
import 'package:sendbird_uikit_sample/utils/app_prefs.dart';

import 'page/basic_sample/group_channel/group_channel_invite_page.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      FlutterError.onError = (errorDetails) {
        debugPrint('[FlutterError] ${errorDetails.stack}');
        Fluttertoast.showToast(
          msg: '[FlutterError] ${errorDetails.stack}',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
        );
      };

      await PushManager.initialize();
      await LocalNotificationsManager.initialize();
      await AppPrefs().initialize();
      // Downloader.initialize(); // Check

      runApp(const MyApp());
    },
    (error, stackTrace) async {
      debugPrint('[Error] $error\n$stackTrace');
      Fluttertoast.showToast(
        msg: '[Error] $error',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sendbird UIKit Sample',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: _createMaterialColor(
          const Color.fromARGB(196, 90, 24, 196),
        ),
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: _AppBehavior(),
          child: UIKit.provider(child: child!),
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        final firstLocale = locales?.first;
        if (firstLocale != null) {
          for (final supportedLocale in supportedLocales) {
            if (firstLocale == supportedLocale) {
              Intl.defaultLocale = firstLocale.toString();
              return firstLocale;
            }
          }
        }

        return supportedLocales.isNotEmpty
            ? supportedLocales.first
            : const Locale('en', 'US');
      },
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/basic_sample_login',
          page: () => const BasicSampleLoginPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/basic_sample',
          page: () => const BasicSamplePage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/list',
          page: () => const GroupChannelListPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/create',
          page: () => const GroupChannelCreatePage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/:channel_url',
          page: () => const GroupChannelPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/information/:message_collection_no',
          page: () => const GroupChannelInformationPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/moderations/:message_collection_no',
          page: () => const GroupChannelModerationsPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/operators/:message_collection_no',
          page: () => const GroupChannelOperatorsPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/muted_members/:message_collection_no',
          page: () => const GroupChannelMutedMembersPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/banned_users/:message_collection_no',
          page: () => const GroupChannelBannedUsersPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/members/:message_collection_no',
          page: () => const GroupChannelMembersPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/group_channel/invite/:message_collection_no',
          page: () => const GroupChannelInvitePage(),
          transition: Transition.noTransition,
        ),
      ],
    );
  }

  MaterialColor _createMaterialColor(Color color) {
    final int r = color.red, g = color.green, b = color.blue;
    final strengths = <double>[.05];
    final Map<int, Color> swatch = {};

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class _AppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
