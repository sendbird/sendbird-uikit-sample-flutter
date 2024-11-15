// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_uikit_sample/uikit/uikit.dart';

class Widgets {
  static Widget scaffold({
    bool noAppBar = false,
    Color? unsafeAreaColor,
    required body,
  }) {
    return Scaffold(
      appBar: noAppBar
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(),
            ),
      backgroundColor: unsafeAreaColor,
      body: unsafeAreaColor != null ? SafeArea(child: body) : body,
    );
  }

  static Widget bottomLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'UIKit v${UIKit.getVersion()}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1,
                  color: const Color(0xFF000000).withOpacity(0.5),
                  decorationThickness: 0,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'SDK v${SendbirdChat.getSdkVersion()}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1,
                  color: const Color(0xFF000000).withOpacity(0.5),
                  decorationThickness: 0,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 93.48,
            height: 16,
            child: Image.asset('assets/images/logo_sendbird_full.png'),
          ),
        ],
      ),
    );
  }
}
