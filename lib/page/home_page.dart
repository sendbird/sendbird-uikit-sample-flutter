// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';
import 'package:sendbird_uikit_sample/notifications/push_manager.dart';
import 'package:sendbird_uikit_sample/utils/app_prefs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    PushManager.removeBadge();

    if (checkSampleChoice() == false) {
      FlutterNativeSplash.remove();
    }
  }

  bool checkSampleChoice() {
    final sampleChoice = AppPrefs().getSampleChoice();
    if (sampleChoice == SampleChoice.basicSample.toString()) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.offAndToNamed('/basic_sample_login');
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: const Color(0xFFF0F0F0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(left: 24, top: 32, right: 24, bottom: 16),
              child: Text(
                'Sendbird UIKit sample',
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
            Expanded(
              child: SingleChildScrollView(
                child: _body(),
              ),
            ),
            Widgets.bottomLogo(),
          ],
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
            height: 72,
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
                onTap: () async {
                  await AppPrefs().setSampleChoice(SampleChoice.basicSample);
                  Get.offAndToNamed('/basic_sample_login');
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 24, top: 24, right: 16, bottom: 24),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Basic sample',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            height: 1.2,
                            color: Color(0xE0000000),
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
