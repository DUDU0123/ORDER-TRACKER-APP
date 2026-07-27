import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:order_tracker_app/controller/order_controller.dart';
import 'package:order_tracker_app/core/colors/app_colors.dart';
import 'package:order_tracker_app/core/components/common_text_form_field_widget.dart';
import 'package:order_tracker_app/core/constants/app_constraints.dart';
import 'package:order_tracker_app/view/pages/orders_list/widgets/date_and_order_amount_show_widget.dart';
import 'package:order_tracker_app/view/pages/orders_list/widgets/order_view_details_button.dart';
import 'package:order_tracker_app/view/pages/orders_list/widgets/user_name_and_status_show_widget.dart';
import 'package:order_tracker_app/view/pages/profile/profile_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({
    super.key,
  });

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  TextEditingController searchController = .new();

  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                Get.to(() => ProfilePage());
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Get.find<OrderController>().getAllOrders();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: CommonTextFormFieldWidget(
                  onChanged: (value) {
                    Get.find<OrderController>().searchOrders(value);
                  },
                  hintText: "Search order...",
                  prefixWidget: const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
                
              Expanded(
                child: GetBuilder<OrderController>(
                  builder: (orderController) {
                    return orderController.orders.isNotEmpty ? ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: orderController.orders.length,
                      separatorBuilder: (context, index) => AppConstraints.kHeight14,
                      itemBuilder: (_, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                UserNameAndStatusShowWidget(order: orderController.orders[index]),
                          
                                AppConstraints.kHeight18,
                          
                                DateAndOrderAmountShowWidget(order: orderController.orders[index]),
                          
                                Divider(height: 28.h),
                          
                                OrderViewDetailsButton(order: orderController.orders[index])
                              ],
                            ),
                          ),
                        );
                      },
                    ) : Center(child: Text("No orders found", style: TextStyle(
                      color: AppColors.kGrey,
                    ),),);
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}