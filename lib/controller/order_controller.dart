import 'package:get/get.dart';
import 'package:order_tracker_app/core/colors/app_colors.dart';
import 'package:order_tracker_app/core/utils/order_status_enum.dart';

import 'package:order_tracker_app/model/data/remote_data/order_data.dart';
import 'package:order_tracker_app/model/order_model.dart';
import 'package:order_tracker_app/services/connection_checker.dart';
import 'package:order_tracker_app/services/shared_prefs_service.dart';

class OrderController extends GetxController {
  final OrderData orderData;
  /// Original list
  List<OrderModel> allOrders = <OrderModel>[].obs;
  /// Search list
  List<OrderModel> orders = [];
  bool isUpdating = false;
  OrderStatusEnum orderStatus = OrderStatusEnum.processing;
  OrderController({
    required this.orderData,
  });

  // Calling getAllOrders() in onInit to fetch orders when the controller is initialized if user is logged in. This ensures that the order list is populated as soon as the user navigates to the order list page.
  @override
  void onInit() {
    if (SharedPrefsService.getUser() != null) {
      getAllOrders();
    }
    super.onInit();
  }

  void selectedOrderStatusUpdate({required OrderStatusEnum? selectedOrderStatus}) {
    orderStatus = selectedOrderStatus ?? OrderStatusEnum.processing;
    update();
  }

  void updateIsUpdatingStatus({required bool value}) {
    isUpdating = value;
    update();
  }

  // method for updating order status
  void updateOrderStatusApi({required String orderId, required String newStatus}) async {
    final isConnected = await ConnectionChecker.checkConnectivity();
    if (!isConnected) {
      Get.snackbar("No Internet", "Check your internet connection.", colorText: AppColors.kRed);
      return;
    }
    updateIsUpdatingStatus(value: true);
    try {
      await orderData.updateOrderStatus(orderId: orderId, status: newStatus);
      Get.snackbar("Updated", "Status updated successfully.");
      updateIsUpdatingStatus(value: false);
      getAllOrders();
    } catch (e) {
      updateIsUpdatingStatus(value: false);
      Get.snackbar("Info", e.toString());
    }
  }

  // method for getting all orders
  Future<void> getAllOrders() async {
    try {
      allOrders = await orderData.getAllOrders();
      // Initially show all orders
      orders = List.from(allOrders);
      update();
    } catch (e) {
      Get.snackbar("Info", e.toString());
    }
  }

  /// Offline Search
  void searchOrders(String query) {
    if (query.trim().isEmpty) {
      orders = List.from(allOrders);
    } else {
      final search = query.toLowerCase().trim();

      orders = allOrders.where((order) {
        final customerName =
            (order.customerName).toLowerCase();

        final status =
            (order.status).toLowerCase();

        final orderId =
            (order.orderNumber).toLowerCase();

        return customerName.contains(search) ||
            status.contains(search) ||
            orderId.contains(search);
      }).toList();
    }

    update();
  }
}
