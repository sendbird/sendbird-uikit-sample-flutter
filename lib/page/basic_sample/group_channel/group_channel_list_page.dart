// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/notifications/push_manager.dart';
import 'package:sendbird_uikit_sample/utils/app_prefs.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelListPage extends StatefulWidget {
  const GroupChannelListPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelListPage> createState() => GroupChannelListPageState();
}

class GroupChannelListPageState extends State<GroupChannelListPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      if (mounted) {
        setState(() {
          activeIndex = tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = context.watch<SBUThemeProvider>().isLight();

    return Widgets.scaffold(
      unsafeAreaColor:
          isLightTheme ? SBUColors.background50 : SBUColors.background600,
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                SBUGroupChannelListScreen(
                  query: GroupChannelListQuery()
                    ..limit = 20
                    ..includeEmpty = false,
                  onCreateButtonClicked: () {
                    Get.toNamed('/group_channel/create');
                  },
                  onListItemClicked: (channel) {
                    Get.toNamed('/group_channel/${channel.channelUrl}');
                  },
                ),
                SBUGroupChannelSettingsScreen(
                  setPushNotifications: (isPushNotificationsOn) async {
                    if (isPushNotificationsOn) {
                      return await PushManager.registerPushToken();
                    } else {
                      return await PushManager.unregisterPushTokenAll();
                    }
                  },
                  onNicknameChanged: (nickname) async {
                    await AppPrefs().setNickname(nickname);
                  },
                ),
              ],
            ),
          ),
          TabBar(
            labelPadding: EdgeInsets.zero,
            indicatorWeight: 0,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide.none,
            ),
            tabs: [
              Container(
                height: 56,
                color: isLightTheme
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF161616),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      SBUIcons.chatFilled,
                      size: 24,
                      color: activeIndex == 0
                          ? (isLightTheme
                              ? const Color(0xFF742DDD)
                              : const Color(0xFFC2A9FA))
                          : (isLightTheme
                              ? const Color(0xFF000000).withOpacity(0.38)
                              : const Color(0xFFFFFFFF).withOpacity(0.38)),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Channels',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1,
                        color: activeIndex == 0
                            ? (isLightTheme
                                ? const Color(0xFF742DDD)
                                : const Color(0xFFC2A9FA))
                            : (isLightTheme
                                ? const Color(0xFF000000).withOpacity(0.38)
                                : const Color(0xFFFFFFFF).withOpacity(0.38)),
                        decorationThickness: 0,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 56,
                color: isLightTheme
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF161616),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      SBUIcons.settingFilled,
                      size: 24,
                      color: activeIndex == 1
                          ? (isLightTheme
                              ? const Color(0xFF742DDD)
                              : const Color(0xFFC2A9FA))
                          : (isLightTheme
                              ? const Color(0xFF000000).withOpacity(0.38)
                              : const Color(0xFFFFFFFF).withOpacity(0.38)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1,
                        color: activeIndex == 1
                            ? (isLightTheme
                                ? const Color(0xFF742DDD)
                                : const Color(0xFFC2A9FA))
                            : (isLightTheme
                                ? const Color(0xFF000000).withOpacity(0.38)
                                : const Color(0xFFFFFFFF).withOpacity(0.38)),
                        decorationThickness: 0,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            controller: tabController,
          ),
        ],
      ),
    );
  }
}
