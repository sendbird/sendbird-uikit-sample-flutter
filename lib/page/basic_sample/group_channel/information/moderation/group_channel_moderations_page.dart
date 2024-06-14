// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelModerationsPage extends StatefulWidget {
  const GroupChannelModerationsPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelModerationsPage> createState() =>
      GroupChannelModerationsPageState();
}

class GroupChannelModerationsPageState
    extends State<GroupChannelModerationsPage> {
  final messageCollectionNo = Get.parameters['message_collection_no']!;

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: SBUGroupChannelModerationsScreen(
        messageCollectionNo: int.parse(messageCollectionNo),
        onOperatorsButtonClicked: (channel) {
          Get.toNamed('/group_channel/operators/$messageCollectionNo');
        },
        onMutedMembersButtonClicked: (channel) {
          Get.toNamed('/group_channel/muted_members/$messageCollectionNo');
        },
        onBannedUsersButtonClicked: (channel) {
          Get.toNamed('/group_channel/banned_users/$messageCollectionNo');
        },
      ),
    );
  }
}
