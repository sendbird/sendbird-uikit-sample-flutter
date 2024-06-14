// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelInvitePage extends StatefulWidget {
  const GroupChannelInvitePage({Key? key}) : super(key: key);

  @override
  State<GroupChannelInvitePage> createState() => GroupChannelInvitePageState();
}

class GroupChannelInvitePageState extends State<GroupChannelInvitePage> {
  final messageCollectionNo = Get.parameters['message_collection_no']!;

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: SBUGroupChannelInviteScreen(
        messageCollectionNo: int.parse(messageCollectionNo),
      ),
    );
  }
}
