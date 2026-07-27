import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:order_tracker_app/controller/order_controller.dart';
import 'package:order_tracker_app/core/utils/order_status_enum.dart';
import 'package:order_tracker_app/model/data/offline_data/local_storage_service.dart';
import 'package:order_tracker_app/model/data/remote_data/order_data.dart';
import 'package:order_tracker_app/model/order_model.dart';

class FakeOrderData extends OrderData {
  final List<OrderModel> mockOrders;
  bool updateCalled = false;
  String? lastUpdatedId;
  String? lastUpdatedStatus;
  bool shouldThrowError = false;

  FakeOrderData({
    required LocalStorageService local,
    required this.mockOrders,
  }) : super(local: local);

  @override
  Future<List<OrderModel>> getAllOrders() async {
    return List.from(mockOrders);
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    if (shouldThrowError) {
      throw Exception('Network error');
    }
    updateCalled = true;
    lastUpdatedId = orderId;
    lastUpdatedStatus = status;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;
  late LocalStorageService localService;
  late FakeOrderData fakeOrderData;
  late OrderController controller;

  final order1 = OrderModel(
    id: 'ord-100',
    orderNumber: 'ORD-100',
    customerName: 'Alice Smith',
    orderDate: DateTime(2026, 7, 27),
    totalPrice: 200.0,
    status: 'Processing',
    createdAt: DateTime(2026, 7, 27),
    updatedAt: DateTime(2026, 7, 27),
  );

  final order2 = OrderModel(
    id: 'ord-200',
    orderNumber: 'ORD-200',
    customerName: 'Bob Johnson',
    orderDate: DateTime(2026, 7, 27),
    totalPrice: 120.0,
    status: 'Delivered',
    createdAt: DateTime(2026, 7, 27),
    updatedAt: DateTime(2026, 7, 27),
  );

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('order_controller_test_');
    Hive.init(tempDir.path);
    await Hive.openBox('orders');
    await Hive.openBox('profile');
    await Hive.openBox('update_queue');
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  setUp(() async {
    await Hive.box('orders').clear();
    await Hive.box('profile').clear();
    await Hive.box('update_queue').clear();

    localService = LocalStorageService();
    fakeOrderData = FakeOrderData(
      local: localService,
      mockOrders: [order1, order2],
    );
    controller = OrderController(orderData: fakeOrderData);
  });

  tearDown(() {
    controller.onClose();
  });

  group('OrderController Tests', () {
    test('getAllOrders populates allOrders and orders lists', () async {
      await controller.getAllOrders();

      expect(controller.allOrders.length, equals(2));
      expect(controller.orders.length, equals(2));
      expect(controller.allOrders.first.id, equals('ord-100'));
    });

    test('searchOrders filters list correctly by customer name, status, or order number', () async {
      await controller.getAllOrders();

      controller.searchOrders('Alice');
      expect(controller.orders.length, equals(1));
      expect(controller.orders.first.customerName, equals('Alice Smith'));

      controller.searchOrders('Delivered');
      expect(controller.orders.length, equals(1));
      expect(controller.orders.first.orderNumber, equals('ORD-200'));

      controller.searchOrders('');
      expect(controller.orders.length, equals(2));
    });

    test('selectedOrderStatusUpdate updates orderStatus property', () {
      controller.selectedOrderStatusUpdate(selectedOrderStatus: OrderStatusEnum.delivered);
      expect(controller.orderStatus, equals(OrderStatusEnum.delivered));
    });

    test('updateIsUpdatingStatus sets loading status', () {
      controller.updateIsUpdatingStatus(value: true);
      expect(controller.isUpdating, isTrue);

      controller.updateIsUpdatingStatus(value: false);
      expect(controller.isUpdating, isFalse);
    });

    test('optimistic UI update modifies local order status instantly', () async {
      await controller.getAllOrders();

      controller.updateOrderStatusApi(orderId: 'ord-100', newStatus: 'Delivered');

      expect(controller.allOrders.firstWhere((o) => o.id == 'ord-100').status, equals('Delivered'));
    });
  });
}
