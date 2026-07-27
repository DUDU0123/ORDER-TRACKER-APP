import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_tracker_app/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
   static late SharedPreferences _prefs;
   static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
   }

    static const userKey = "USER_KEY";

  /// GET USER DATA
  static ProfileModel? getUser() {
    final data = _prefs.getString(userKey);
    if (data?.isNotEmpty == true) {
      return ProfileModel.fromRawJson(data ?? '{}');
    } else {
      debugPrint("No user data found.");
      return null;
    }
  }

  /// SET USER DATA
  static Future<bool?> setUser(ProfileModel? user) async{
    return await _prefs.setString(userKey, user != null ? jsonEncode(user.toJson()) : '');
  }
}