import 'package:flutter_test/flutter_test.dart';
import 'package:order_tracker_app/model/order_item_model.dart';
import 'package:order_tracker_app/model/order_model.dart';

void main() {
  group('OrderModel & OrderItemModel Tests', () {
    final sampleItemJson = {
      'id': 'item-1',
      'order_id': 'order-101',
      'product_name': 'Wireless Headphones',
      'quantity': 2,
      'price': 49.99,
    };

    final sampleOrderJson = {
      'id': 'order-101',
      'order_number': 'ORD-2026-001',
      'customer_name': 'John Doe',
      'order_date': '2026-07-27T09:00:00.000Z',
      'total_price': 99.98,
      'status': 'Processing',
      'created_at': '2026-07-27T09:00:00.000Z',
      'updated_at': '2026-07-27T09:30:00.000Z',
      'order_items': [sampleItemJson],
    };

    test('OrderItemModel.fromJson and toJson should match', () {
      final item = OrderItemModel.fromJson(sampleItemJson);
      expect(item.id, equals('item-1'));
      expect(item.productName, equals('Wireless Headphones'));
      expect(item.quantity, equals(2));
      expect(item.price, equals(49.99));

      final json = item.toJson();
      expect(json['id'], equals('item-1'));
      expect(json['product_name'], equals('Wireless Headphones'));
      expect(json['quantity'], equals(2));
      expect(json['price'], equals(49.99));
    });

    test('OrderModel.fromJson should parse correctly', () {
      final order = OrderModel.fromJson(sampleOrderJson);
      expect(order.id, equals('order-101'));
      expect(order.orderNumber, equals('ORD-2026-001'));
      expect(order.customerName, equals('John Doe'));
      expect(order.totalPrice, equals(99.98));
      expect(order.status, equals('Processing'));
      expect(order.items.length, equals(1));
      expect(order.items.first.productName, equals('Wireless Headphones'));
    });

    test('OrderModel.toJson should output correct map format', () {
      final order = OrderModel.fromJson(sampleOrderJson);
      final json = order.toJson();
      expect(json['id'], equals('order-101'));
      expect(json['order_number'], equals('ORD-2026-001'));
      expect(json['customer_name'], equals('John Doe'));
      expect(json['status'], equals('Processing'));
      expect((json['order_items'] as List).length, equals(1));
    });

    test('OrderModel.copyWith should produce updated copy', () {
      final order = OrderModel.fromJson(sampleOrderJson);
      final updatedOrder = order.copyWith(status: 'Shipped');

      expect(updatedOrder.id, equals(order.id));
      expect(updatedOrder.status, equals('Shipped'));
      expect(order.status, equals('Processing'));
    });
  });
}
