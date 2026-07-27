import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:order_tracker_app/model/order_model.dart';

class LocalStorageService {

  Box get orderBox => Hive.box('orders');
  Box get profileBox => Hive.box('profile');
  Box get updateQueueBox => Hive.box('update_queue');

  //---------------- Orders ----------------//

  Future<void> saveOrders(List<OrderModel> orders) async {

    final data = orders.map((e)=>e.toJson()).toList();

    await orderBox.put("orders", data);
  }

  List<OrderModel> getOrders() {
    try {
      final data = orderBox.get("orders");

      if(data==null){
        return [];
      }
      return (data as List).map((e)=>OrderModel.fromJson(Map<String,dynamic>.from(e))).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveOrder(OrderModel order) async{
    try {
      final orders = getOrders();

      final index = orders.indexWhere((e)=>e.id==order.id);

      if(index==-1){
        orders.add(order);
      }else{
        orders[index]=order;
      }
    await saveOrders(orders);
    } catch (e) {
      return;
    }
  }

  //---------------- Update Queue ----------------//

  Future<void> savePendingUpdate({
    required String orderId,
    required String status,
  }) async {
    try {
      final updateData = {
        'orderId': orderId,
        'status': status,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await updateQueueBox.put(orderId, updateData);
    } catch (e) {
      debugPrint('Error saving pending update: $e');
    }
  }

  List<Map<String, dynamic>> getPendingUpdates() {
    try {
      final keys = updateQueueBox.keys;
      final List<Map<String, dynamic>> updates = [];
      for (final key in keys) {
        final val = updateQueueBox.get(key);
        if (val != null) {
          updates.add(Map<String, dynamic>.from(val as Map));
        }
      }
      return updates;
    } catch (e) {
      return [];
    }
  }

  Future<void> removePendingUpdate(String orderId) async {
    try {
      await updateQueueBox.delete(orderId);
    } catch (e) {
      debugPrint('Error removing pending update: $e');
    }
  }

  Future<void> clearPendingUpdates() async {
    try {
      await updateQueueBox.clear();
    } catch (e) {
      debugPrint('Error clearing pending updates: $e');
    }
  }
}