// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelCreatePage extends StatefulWidget {
  const GroupChannelCreatePage({Key? key}) : super(key: key);

  @override
  State<GroupChannelCreatePage> createState() => GroupChannelCreatePageState();
}

class GroupChannelCreatePageState extends State<GroupChannelCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: SBUGroupChannelCreateScreen(
        onChannelCreated: (channel) {
          Get.toNamed('/group_channel/${channel.channelUrl}');
        },
      ),
    );
  }
}
