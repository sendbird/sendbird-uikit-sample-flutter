// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_uikit_sample/notifications/push_manager.dart';
import 'package:sendbird_uikit_sample/uikit/uikit.dart';
import 'package:sendbird_uikit_sample/utils/app_prefs.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class BasicSamplePage extends StatefulWidget {
  const BasicSamplePage({Key? key}) : super(key: key);

  @override
  State<BasicSamplePage> createState() => _BasicSamplePageState();
}

class _BasicSamplePageState extends State<BasicSamplePage> {
  int? groupChannelCount;

  @override
  void initState() {
    super.initState();

    _getTotalUnreadMessageCount();
  }

  void _getTotalUnreadMessageCount() {
    runZonedGuarded(() {
      SendbirdChat.getTotalUnreadMessageCount().then((count) {
        if (mounted) {
          setState(() => groupChannelCount = count);
        }
      });
    }, (error, stack) {
      // TODO: Check
    });
  }

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: const Color(0xFFF0F0F0),
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            color: const Color(0xFFF0F0F0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 24, top: 32, right: 24, bottom: 16),
                  child: Text(
                    'Basic sample',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 1.172,
                      color: Color(0xE0000000),
                      decorationThickness: 0,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
                _body(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, top: 24, right: 24, bottom: 24),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        runZonedGuarded(() async {
                          await PushManager.unregisterPushTokenAll();
                          if (await UIKit.logout()) {
                            await AppPrefs().removeUserId();
                            await AppPrefs().removeNickname();

                            Get.offAndToNamed('/basic_sample_login');
                          }
                        }, (error, stack) {
                          // TODO: Check
                        });
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFF000000).withOpacity(0.88),
                          ),
                        ),
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'SIGN OUT',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.143,
                            color: const Color(0xFF000000).withOpacity(0.88),
                            decorationThickness: 0,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 24, top: 8, right: 24, bottom: 8),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.12),
                  spreadRadius: 0,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.toNamed('/group_channel/list')?.then((_) {
                    _getTotalUnreadMessageCount();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 24, top: 24, right: 16, bottom: 24),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Group channel',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                height: 1.2,
                                color: Color(0xE0000000),
                                decorationThickness: 0,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '1 on 1, Group chat with members',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.143,
                                color: const Color(0xFF000000).withOpacity(0.5),
                                decorationThickness: 0,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (groupChannelCount != null && groupChannelCount! > 0)
                        const SizedBox(width: 8),
                      if (groupChannelCount != null && groupChannelCount! > 0)
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDE360B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.5, vertical: 4),
                          child: Text(
                            groupChannelCount.toString(),
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              height: 1,
                              color: const Color(0xFFFFFFFF).withOpacity(0.88),
                              decorationThickness: 0,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            Image.asset('assets/images/icon-chevron-right.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
