import 'package:flutter/material.dart';
import 'package:order_tracker_app/core/colors/app_colors.dart';
import 'package:order_tracker_app/core/utils/order_status_enum.dart';

class AppCommonMethods {
  static Color getStatusColor({required OrderStatusEnum status}) {
    if (status == OrderStatusEnum.pending) {
      return AppColors.kOrange;
    } if (status == OrderStatusEnum.processing) {
      return AppColors.kBlue;
    } if (status == OrderStatusEnum.delivered) {
      return AppColors.kGreen;
    } if (status == OrderStatusEnum.cancelled) {
      return AppColors.kRed;
    } else {
      return AppColors.kGrey;
    }
  }

  static String getOrderStatusString({required OrderStatusEnum status}) {
    if (status == OrderStatusEnum.pending) {
      return "Pending";
    } if (status == OrderStatusEnum.processing) {
      return "Processing";
    } if (status == OrderStatusEnum.delivered) {
      return "Delivered";
    } if (status == OrderStatusEnum.cancelled) {
      return "Cancelled";
    } else {
      return "";
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
