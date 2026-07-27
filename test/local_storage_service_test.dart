import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:order_tracker_app/model/data/offline_data/local_storage_service.dart';
import 'package:order_tracker_app/model/order_model.dart';

void main() {
  late Directory tempDir;
  late LocalStorageService localStorageService;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    await Hive.openBox('orders');
    await Hive.openBox('profile');
    await Hive.openBox('update_queue');
    localStorageService = LocalStorageService();
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  setUp(() async {
    await Hive.box('orders').clear();
    await Hive.box('profile').clear();
    await Hive.box('update_queue').clear();
  });

  group('LocalStorageService Tests', () {
    final sampleOrder = OrderModel(
      id: 'ord-1',
      orderNumber: 'ORD-001',
      customerName: 'Alice',
      orderDate: DateTime(2026, 7, 27),
      totalPrice: 150.0,
      status: 'Processing',
      createdAt: DateTime(2026, 7, 27),
      updatedAt: DateTime(2026, 7, 27),
    );

    test('saveOrders and getOrders work correctly', () async {
      await localStorageService.saveOrders([sampleOrder]);
      final orders = localStorageService.getOrders();
      expect(orders.length, equals(1));
      expect(orders.first.id, equals('ord-1'));
      expect(orders.first.customerName, equals('Alice'));
    });

    test('saveOrder adds new and updates existing order', () async {
      await localStorageService.saveOrder(sampleOrder);
      expect(localStorageService.getOrders().length, equals(1));

      final updatedOrder = sampleOrder.copyWith(status: 'Delivered');
      await localStorageService.saveOrder(updatedOrder);

      final orders = localStorageService.getOrders();
      expect(orders.length, equals(1));
      expect(orders.first.status, equals('Delivered'));
    });

    test('savePendingUpdate, getPendingUpdates, and removePendingUpdate work correctly', () async {
      await localStorageService.savePendingUpdate(
        orderId: 'ord-1',
        status: 'Cancelled',
      );

      var pending = localStorageService.getPendingUpdates();
      expect(pending.length, equals(1));
      expect(pending.first['orderId'], equals('ord-1'));
      expect(pending.first['status'], equals('Cancelled'));

      await localStorageService.removePendingUpdate('ord-1');
      pending = localStorageService.getPendingUpdates();
      expect(pending.isEmpty, isTrue);
    });

    test('clearPendingUpdates empties update queue box', () async {
      await localStorageService.savePendingUpdate(orderId: 'ord-1', status: 'Shipped');
      await localStorageService.savePendingUpdate(orderId: 'ord-2', status: 'Delivered');

      expect(localStorageService.getPendingUpdates().length, equals(2));

      await localStorageService.clearPendingUpdates();
      expect(localStorageService.getPendingUpdates().isEmpty, isTrue);
    });
  });
}
