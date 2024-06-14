// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit_sample/uikit/uikit.dart';
import 'package:sendbird_uikit_sample/utils/app_prefs.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';

class BasicSampleLoginPage extends StatefulWidget {
  const BasicSampleLoginPage({Key? key}) : super(key: key);

  @override
  State<BasicSampleLoginPage> createState() => _BasicSampleLoginPageState();
}

class _BasicSampleLoginPageState extends State<BasicSampleLoginPage> {
  final appIdController = TextEditingController();
  final userIdController = TextEditingController();
  final nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    appIdController.dispose();
    userIdController.dispose();
    nicknameController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      appIdController.text = AppPrefs().getAppId();
      userIdController.text = AppPrefs().getUserId();
      nicknameController.text = AppPrefs().getNickname();

      await UIKit.login(
        appIdController.text,
        userIdController.text,
        nicknameController.text,
      );
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Widgets.scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: const Color(0xFFFFFFFF),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.asset('assets/images/logo_sendbird.png'),
                ),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 24, bottom: 16),
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
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _body(),
                    Widgets.bottomLogo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 28, right: 24, bottom: 63),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: appIdController,
                    onChanged: (text) {
                      appIdController.value = TextEditingValue(
                        text: text.toUpperCase(),
                        selection: appIdController.selection,
                      );
                    },
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.2,
                      // 1.5
                      color: const Color(0xFF000000).withOpacity(0.88),
                      decorationThickness: 0,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                    minLines: 1,
                    maxLines: 2,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, top: 10, right: 16, bottom: 4),
                      hintText: 'App ID',
                      hintStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.25,
                        color: const Color(0xFF000000).withOpacity(0.38),
                        decorationThickness: 0,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      floatingLabelStyle: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1.4,
                        // 1
                        color: Color(0xFF742DDD),
                        decorationThickness: 0,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 95,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF742DDD),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await AppPrefs().setAppId(appIdController.text);
                    },
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1.143,
                          color: const Color(0xFFFFFFFF).withOpacity(0.88),
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
          const SizedBox(height: 24),
          Container(
            width: double.maxFinite,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: userIdController,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.2,
                // 1.5
                color: const Color(0xFF000000).withOpacity(0.88),
                decorationThickness: 0,
                leadingDistribution: TextLeadingDistribution.even,
              ),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                    left: 16, top: 10, right: 16, bottom: 10),
                labelText: 'User ID',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.25,
                  color: const Color(0xFF000000).withOpacity(0.38),
                  decorationThickness: 0,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                floatingLabelStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1.4,
                  // 1
                  color: Color(0xFF742DDD),
                  decorationThickness: 0,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.maxFinite,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: nicknameController,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.2,
                // 1.5
                color: const Color(0xFF000000).withOpacity(0.88),
                decorationThickness: 0,
                leadingDistribution: TextLeadingDistribution.even,
              ),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                    left: 16, top: 10, right: 16, bottom: 10),
                labelText: 'Nickname',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.25,
                  color: const Color(0xFF000000).withOpacity(0.38),
                  decorationThickness: 0,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                floatingLabelStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1.4,
                  // 1
                  color: Color(0xFF742DDD),
                  decorationThickness: 0,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.maxFinite,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF742DDD),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await UIKit.login(
                    appIdController.text,
                    userIdController.text,
                    nicknameController.text,
                  );
                },
                child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.143,
                      color: const Color(0xFFFFFFFF).withOpacity(0.88),
                      decorationThickness: 0,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await AppPrefs().removeSampleChoice();
                Get.offAndToNamed('/home');
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Image.asset('assets/images/icon-chevron-left.png'),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Select sample apps',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.143,
                        color: Color(0xFF742DDD),
                        decorationThickness: 0,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
