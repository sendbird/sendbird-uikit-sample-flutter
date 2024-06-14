// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelBannedUsersPage extends StatefulWidget {
  const GroupChannelBannedUsersPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelBannedUsersPage> createState() =>
      GroupChannelBannedUsersPageState();
}

class GroupChannelBannedUsersPageState
    extends State<GroupChannelBannedUsersPage> {
  final messageCollectionNo = Get.parameters['message_collection_no']!;

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: SBUGroupChannelBannedUsersScreen(
        messageCollectionNo: int.parse(messageCollectionNo),
      ),
    );
  }
}
