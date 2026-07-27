import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracker_app/core/colors/app_colors.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case "Pending":
        color = AppColors.kOrange;
        break;

      case "Processing":
        color = AppColors.kBlue;
        break;

      case "Delivered":
        color = AppColors.kGreen;
        break;

      case "Cancelled":
        color = AppColors.kRed;
        break;

      default:
        color = AppColors.kGrey;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 7.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}