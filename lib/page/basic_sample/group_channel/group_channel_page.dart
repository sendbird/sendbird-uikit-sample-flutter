// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelPage extends StatefulWidget {
  const GroupChannelPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelPage> createState() => GroupChannelPageState();
}

class GroupChannelPageState extends State<GroupChannelPage> {
  final channelUrl = Get.parameters['channel_url']!;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = context.watch<SBUThemeProvider>().isLight();

    return Widgets.scaffold(
      unsafeAreaColor:
          isLightTheme ? SBUColors.background50 : SBUColors.background600,
      body: SBUGroupChannelScreen(
        channelUrl: channelUrl,
        params: MessageListParams()..previousResultSize = 40,
        onChannelDeleted: (channel) {
          Get.until((route) => Get.currentRoute == '/group_channel/list');
        },
        onInfoButtonClicked: (messageCollectionNo) {
          Get.toNamed('/group_channel/information/$messageCollectionNo');
        },
        on1On1ChannelCreated: (channel) {
          Get.toNamed('/group_channel/${channel.channelUrl}');
        },
      ),
    );
  }
}
