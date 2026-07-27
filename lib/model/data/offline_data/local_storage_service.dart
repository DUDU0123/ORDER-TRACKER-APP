import 'package:hive_flutter/hive_flutter.dart';
import 'package:order_tracker_app/model/order_model.dart';

class LocalStorageService {

  final Box orderBox = Hive.box('orders');
  final Box profileBox = Hive.box('profile');

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
}