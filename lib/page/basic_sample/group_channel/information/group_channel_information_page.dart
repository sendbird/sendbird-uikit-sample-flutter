// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelInformationPage extends StatefulWidget {
  const GroupChannelInformationPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelInformationPage> createState() =>
      GroupChannelInformationPageState();
}

class GroupChannelInformationPageState
    extends State<GroupChannelInformationPage> {
  final messageCollectionNo = Get.parameters['message_collection_no']!;

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: SBUGroupChannelInformationScreen(
        messageCollectionNo: int.parse(messageCollectionNo),
        onChannelLeft: (channel) {
          Get.until((route) => Get.currentRoute == '/group_channel/list');
        },
        onModerationsButtonClicked: (channel) {
          Get.toNamed('/group_channel/moderations/$messageCollectionNo');
        },
        onMembersButtonClicked: (channel) {
          Get.toNamed('/group_channel/members/$messageCollectionNo');
        },
      ),
    );
  }
}
