import 'dart:async';
import 'package:flutter/material.dart';
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
  bool isSyncing = false;
  OrderStatusEnum orderStatus = OrderStatusEnum.processing;

  StreamSubscription<bool>? _connectivitySubscription;

  OrderController({required this.orderData});

  // Calling getAllOrders() in onInit to fetch orders when the controller is initialized if user is logged in. This ensures that the order list is populated as soon as the user navigates to the order list page.
  @override
  void onInit() {
    if (SharedPrefsService.getUser() != null) {
      getAllOrders();
    }
    _listenToConnectivity();
    super.onInit();
  }

  void _listenToConnectivity() {
    _connectivitySubscription = ConnectionChecker().connectionStream.listen((
      isConnected,
    ) {
      if (isConnected) {
        syncPendingUpdates();
      }
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void selectedOrderStatusUpdate({
    required OrderStatusEnum? selectedOrderStatus,
  }) {
    orderStatus = selectedOrderStatus ?? OrderStatusEnum.processing;
    update();
  }

  void updateIsUpdatingStatus({required bool value}) {
    isUpdating = value;
    update();
  }

  void showSnackbar(String title, String message, {Color? colorText}) {
    if (Get.context != null) {
      Get.snackbar(title, message, colorText: colorText);
    }
  }

  // method for updating order status
  void updateOrderStatusApi({
    required String orderId,
    required String newStatus,
  }) async {
    updateIsUpdatingStatus(value: true);

    // Optimistically update local order state
    _optimisticallyUpdateOrder(orderId: orderId, newStatus: newStatus);

    final isConnected = await ConnectionChecker.checkConnectivity();
    if (!isConnected) {
      await orderData.local.savePendingUpdate(
        orderId: orderId,
        status: newStatus,
      );
      updateIsUpdatingStatus(value: false);
      showSnackbar(
        "Offline Mode",
        "Status updated locally and queued for auto-sync when online.",
        colorText: AppColors.kOrange,
      );
      return;
    }

    try {
      await orderData.updateOrderStatus(orderId: orderId, status: newStatus);
      await orderData.local.removePendingUpdate(orderId);
      showSnackbar("Updated", "Status updated successfully.");
      updateIsUpdatingStatus(value: false);
      await getAllOrders();
    } catch (e) {
      await orderData.local.savePendingUpdate(
        orderId: orderId,
        status: newStatus,
      );
      updateIsUpdatingStatus(value: false);
      showSnackbar(
        "Saved Offline",
        "Network request failed. Queued for auto-sync.",
        colorText: AppColors.kOrange,
      );
    }
  }

  void _optimisticallyUpdateOrder({
    required String orderId,
    required String newStatus,
  }) {
    final index = allOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final updatedOrder = allOrders[index].copyWith(status: newStatus);
      allOrders[index] = updatedOrder;

      final searchIndex = orders.indexWhere((o) => o.id == orderId);
      if (searchIndex != -1) {
        orders[searchIndex] = updatedOrder;
      }
      orderData.local.saveOrder(updatedOrder);
      update();
    }
  }

  // method to sync pending updates queued offline
  Future<void> syncPendingUpdates() async {
    if (isSyncing) return;
    final pendingUpdates = orderData.local.getPendingUpdates();
    if (pendingUpdates.isEmpty) return;

    final isConnected = await ConnectionChecker.checkConnectivity();
    if (!isConnected) return;

    isSyncing = true;
    update();

    int successCount = 0;
    for (final updateItem in pendingUpdates) {
      final orderId = updateItem['orderId'] as String?;
      final status = updateItem['status'] as String?;
      if (orderId != null && status != null) {
        try {
          await orderData.updateOrderStatus(orderId: orderId, status: status);
          await orderData.local.removePendingUpdate(orderId);
          successCount++;
        } catch (e) {
          // keep in queue if sync attempt fails
        }
      }
    }

    isSyncing = false;
    update();

    if (successCount > 0) {
      showSnackbar(
        "Sync Complete",
        "$successCount offline update(s) synchronized with server.",
      );
      await getAllOrders();
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
      showSnackbar("Info", e.toString());
    }
  }

  /// Offline Search
  void searchOrders(String query) {
    if (query.trim().isEmpty) {
      orders = List.from(allOrders);
    } else {
      final search = query.toLowerCase().trim();

      orders = allOrders.where((order) {
        final customerName = (order.customerName).toLowerCase();

        final status = (order.status).toLowerCase();

        final orderId = (order.orderNumber).toLowerCase();

        return customerName.contains(search) ||
            status.contains(search) ||
            orderId.contains(search);
      }).toList();
    }

    update();
  }
}
