import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracker_app/core/constants/app_constraints.dart';
import 'package:order_tracker_app/model/order_model.dart';
import 'package:order_tracker_app/view/pages/order_detail/widgets/status_chip.dart';

class UserNameAndStatusShowWidget extends StatelessWidget {
  const UserNameAndStatusShowWidget({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            order.customerName[0],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
        ),

        AppConstraints.kWidth15,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.customerName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
              ),

              AppConstraints.kHeight4,

              Text(
                order.orderNumber,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        StatusChip(status: order.status),
      ],
    );
  }
}
