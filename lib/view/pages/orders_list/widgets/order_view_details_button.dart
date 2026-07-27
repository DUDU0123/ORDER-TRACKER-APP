import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracker_app/model/order_model.dart';
import 'package:order_tracker_app/view/pages/order_detail/order_detail_page.dart';

class OrderViewDetailsButton extends StatelessWidget {
  const OrderViewDetailsButton({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailPage(
              order: order,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Text(
            "View Details",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, size: 18.sp),
        ],
      ),
    );
  }
}
