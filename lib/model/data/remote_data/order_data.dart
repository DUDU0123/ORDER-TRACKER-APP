import 'package:flutter/material.dart';
import 'package:order_tracker_app/model/data/offline_data/local_storage_service.dart';
import 'package:order_tracker_app/model/order_model.dart';
import 'package:order_tracker_app/services/connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderData {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LocalStorageService local;

  OrderData({required this.local});

  /// Fetching all orders
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final hasInternet = await ConnectionChecker.checkConnectivity();
      if (hasInternet) {
        final response = await _supabase
          .from('orders')
          .select()
          .order('order_date', ascending: false);

      // return response
      //     .map<OrderModel>((json) => OrderModel.fromJson(json))
      //     .toList();
      final orders = response
          .map<OrderModel>((json) => OrderModel.fromJson(json))
          .toList();
      // Saving locally
      await local.saveOrders(orders);
      return orders;
      } else {
        return local.getOrders();
      }
    } catch (e) {
      debugPrint('Error fetching all orders: $e');
      throw Exception('Failed to fetch orders');
    }
  }

  /// Fetching order by ID with its items
  Future<OrderModel> getOrderById(String orderId) async {
    final hasInternet = await ConnectionChecker.checkConnectivity();
    try {
      if (hasInternet) {
        final response = await _supabase
        .from('orders')
        .select('''
          *,
          order_items(*)
        ''')
        .eq('id', orderId)
        .single();

      final order = OrderModel.fromJson(response);

      await local.saveOrder(order);

      return order;
      } else {
        return local
      .getOrders()
      .firstWhere((e)=>e.id==orderId);
      }
    } catch (e) {
      debugPrint('Error fetching order by ID: $e');
      throw Exception('Failed to fetch order');
    }
  }

  /// Update order status
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      await _supabase
        .from('orders')
        .update({
          'status': status,
        })
        .eq('id', orderId);
    } catch (e) {
      debugPrint('Error on update order status: $e');
      throw Exception('Failed to update order status ${e.toString()}');
    }
  }

  // /// Filter orders by status
  // Future<List<OrderModel>> filterOrders(String status) async {
  //   final response = await _supabase
  //       .from('orders')
  //       .select()
  //       .eq('status', status);

  //   return response
  //       .map<OrderModel>((json) => OrderModel.fromJson(json))
  //       .toList();
  // }
}