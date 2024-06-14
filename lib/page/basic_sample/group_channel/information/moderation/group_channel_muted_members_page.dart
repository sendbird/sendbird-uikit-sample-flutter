// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelMutedMembersPage extends StatefulWidget {
  const GroupChannelMutedMembersPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelMutedMembersPage> createState() =>
      GroupChannelMutedMembersPageState();
}

class GroupChannelMutedMembersPageState
    extends State<GroupChannelMutedMembersPage> {
  final messageCollectionNo = Get.parameters['message_collection_no']!;

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: SBUGroupChannelMutedMembersScreen(
        messageCollectionNo: int.parse(messageCollectionNo),
      ),
    );
  }
}
