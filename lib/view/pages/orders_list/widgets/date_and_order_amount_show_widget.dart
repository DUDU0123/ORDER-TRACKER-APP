import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:order_tracker_app/core/constants/app_constraints.dart';
import 'package:order_tracker_app/model/order_model.dart';

class DateAndOrderAmountShowWidget extends StatelessWidget {
  const DateAndOrderAmountShowWidget({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.calendar_today_outlined, size: 18.sp),
        AppConstraints.kWidth8,

        Text(DateFormat("dd MMM yyyy").format(order.orderDate)),

        const Spacer(),

        Icon(Icons.attach_money, size: 20.sp),

        Text(
          order.totalPrice.toStringAsFixed(2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
