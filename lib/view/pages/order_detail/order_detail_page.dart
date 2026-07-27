import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:order_tracker_app/core/constants/app_constraints.dart';
import 'package:order_tracker_app/core/utils/app_common_methods.dart';
import 'package:order_tracker_app/model/order_model.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () {
            },
            child: const Text("Update Status"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ORDER SUMMARY
            Card(
              elevation: 0,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [

                    Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                order.orderNumber,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              AppConstraints.kHeight6,

                              Text(DateFormat("dd MMM yyyy").format(order.orderDate)),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppCommonMethods.getStatusColor(selectedStatus).withOpacity(.15),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            selectedStatus,
                            style: TextStyle(
                              color: AppCommonMethods.getStatusColor(selectedStatus),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            AppConstraints.kHeight25,

            Text(
              "Customer",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            AppConstraints.kHeight12,

            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(order.customerName[0]),
                ),
                title: Text(order.customerName),
                subtitle: const Text("Customer"),
              ),
            ),

            AppConstraints.kHeight25,

            Text(
              "Products",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            AppConstraints.kHeight12,

            ...order.items.map((item) {
              return Card(
                margin: EdgeInsets.only(bottom: 12.h),
                child: ListTile(
                  title: Text(item.productName),
                  subtitle: Text(
                    "Qty : ${item.quantity}",
                  ),
                  trailing: Text(
                    "\$${item.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),

            AppConstraints.kHeight25,

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [

                    Text(
                      "Total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "\$${order.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    )
                  ],
                ),
              ),
            ),

            AppConstraints.kHeight30,

            Text(
              "Update Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),

            AppConstraints.kHeight12,

            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Pending",
                  child: Text("Pending"),
                ),
                DropdownMenuItem(
                  value: "Processing",
                  child: Text("Processing"),
                ),
                DropdownMenuItem(
                  value: "Delivered",
                  child: Text("Delivered"),
                ),
                DropdownMenuItem(
                  value: "Cancelled",
                  child: Text("Cancelled"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),

            AppConstraints.kHeight100,
          ],
        ),
      ),
    );
  }
}