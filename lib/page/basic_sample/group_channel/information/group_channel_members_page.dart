// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelMembersPage extends StatefulWidget {
  const GroupChannelMembersPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelMembersPage> createState() =>
      GroupChannelMembersPageState();
}

class GroupChannelMembersPageState extends State<GroupChannelMembersPage> {
  final messageCollectionNo = Get.parameters['message_collection_no']!;

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: SBUGroupChannelMembersScreen(
        messageCollectionNo: int.parse(messageCollectionNo),
        onInviteButtonClicked: (channel) {
          Get.toNamed('/group_channel/invite/$messageCollectionNo');
        },
      ),
    );
  }
}
