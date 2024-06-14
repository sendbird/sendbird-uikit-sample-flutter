// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class GroupChannelOperatorsPage extends StatefulWidget {
  const GroupChannelOperatorsPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelOperatorsPage> createState() =>
      GroupChannelOperatorsPageState();
}

class GroupChannelOperatorsPageState extends State<GroupChannelOperatorsPage> {
  final messageCollectionNo = Get.parameters['message_collection_no']!;

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: SBUGroupChannelOperatorsScreen(
        messageCollectionNo: int.parse(messageCollectionNo),
      ),
    );
  }
}
