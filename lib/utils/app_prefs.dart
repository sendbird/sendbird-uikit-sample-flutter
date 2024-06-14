// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:shared_preferences/shared_preferences.dart';

enum SampleChoice {
  basicSample,
}

class AppPrefs {
  static const String prefSampleChoice = 'prefSampleChoice';
  static const String prefAppId = 'prefAppId';
  static const String prefUserId = 'prefUserId';
  static const String prefNickname = 'prefNickname';

  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  factory AppPrefs() {
    return _instance;
  }

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  // Sample choice
  Future<bool> setSampleChoice(SampleChoice sampleChoice) async {
    return await _prefs.setString(prefSampleChoice, sampleChoice.toString());
  }

  String? getSampleChoice() {
    return _prefs.getString(prefSampleChoice);
  }

  Future<bool> removeSampleChoice() async {
    return await _prefs.remove(prefSampleChoice);
  }

  // App ID
  Future<bool> setAppId(String appId) async {
    return await _prefs.setString(prefAppId, appId);
  }

  String getAppId() {
    return _prefs.getString(prefAppId) ?? '';
  }

  Future<bool> removeAppId() async {
    return await _prefs.remove(prefAppId);
  }

  // User ID
  Future<bool> setUserId(String userId) async {
    return await _prefs.setString(prefUserId, userId);
  }

  String getUserId() {
    return _prefs.getString(prefUserId) ?? '';
  }

  Future<bool> removeUserId() async {
    return await _prefs.remove(prefUserId);
  }

  // Nickname
  Future<bool> setNickname(String nickname) async {
    return await _prefs.setString(prefNickname, nickname);
  }

  String getNickname() {
    return _prefs.getString(prefNickname) ?? '';
  }

  Future<bool> removeNickname() async {
    return await _prefs.remove(prefNickname);
  }
}
