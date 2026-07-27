import 'package:flutter/material.dart';
import 'package:order_tracker_app/core/colors/app_colors.dart';

class AppCommonMethods {
  static Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return AppColors.kOrange;
      case "Processing":
        return AppColors.kBlue;
      case "Delivered":
        return AppColors.kGreen;
      case "Cancelled":
        return AppColors.kRed;
      default:
        return AppColors.kGrey;
    }
  }

  static String? emailValidator({required String? value}) {
    try {
      if (value == null || value.trim().isEmpty) {
        return "Email is required";
      }

      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
        return "Enter a valid email";
      }
      return null;
    } catch (e) {
      debugPrint("Error in emailValidator: $e");
      return null;
    }
  }

  static String? passwordValidator({required String? value}) {
    try {
      if (value == null || value.isEmpty) {
        return "Password is required";
      }

      if (value.length < 8) {
        return "Minimum 8 characters required";
      }

      return null;
    } catch (e) {
      debugPrint("Error in passwordValidator: $e");
      return null;
    }
  }
}
