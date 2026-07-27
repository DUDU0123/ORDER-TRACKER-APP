import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_tracker_app/model/order_model.dart';
import 'package:order_tracker_app/view/pages/profile/profile_page.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search customer...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 14),
              itemBuilder: (_, index) {
                final order = orders[index];

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
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Colors.blue.shade100,
                              child: Text(
                                order.customerName[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.customerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    order.orderNumber,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _StatusChip(
                              status: order.status,
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                            ),

                            const SizedBox(width: 8),

                            Text(
                              DateFormat("dd MMM yyyy")
                                  .format(order.orderDate),
                            ),

                            const Spacer(),

                            const Icon(
                              Icons.attach_money,
                              size: 20,
                            ),

                            Text(
                              order.totalPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 28),

                        Row(
                          children: const [
                            Text(
                              "View Details",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 18),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case "Pending":
        color = Colors.orange;
        break;

      case "Processing":
        color = Colors.blue;
        break;

      case "Delivered":
        color = Colors.green;
        break;

      case "Cancelled":
        color = Colors.red;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}




final List<OrderModel> orders = [
  OrderModel(
    id: "1",
    orderNumber: "ORD1001",
    customerName: "John Smith",
    orderDate: DateTime(2026, 7, 15),
    totalPrice: 259.99,
    status: "Pending",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "2",
    orderNumber: "ORD1002",
    customerName: "Alice Johnson",
    orderDate: DateTime(2026, 7, 16),
    totalPrice: 145.50,
    status: "Processing",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "3",
    orderNumber: "ORD1003",
    customerName: "Michael Brown",
    orderDate: DateTime(2026, 7, 16),
    totalPrice: 599.99,
    status: "Delivered",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "4",
    orderNumber: "ORD1004",
    customerName: "Emma Wilson",
    orderDate: DateTime(2026, 7, 17),
    totalPrice: 320.00,
    status: "Cancelled",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "5",
    orderNumber: "ORD1005",
    customerName: "David Lee",
    orderDate: DateTime(2026, 7, 17),
    totalPrice: 180.75,
    status: "Pending",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "6",
    orderNumber: "ORD1006",
    customerName: "Sophia Taylor",
    orderDate: DateTime(2026, 7, 18),
    totalPrice: 430.20,
    status: "Processing",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "7",
    orderNumber: "ORD1007",
    customerName: "James Anderson",
    orderDate: DateTime(2026, 7, 18),
    totalPrice: 899.99,
    status: "Delivered",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "8",
    orderNumber: "ORD1008",
    customerName: "Olivia Thomas",
    orderDate: DateTime(2026, 7, 19),
    totalPrice: 110.00,
    status: "Pending",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "9",
    orderNumber: "ORD1009",
    customerName: "William Harris",
    orderDate: DateTime(2026, 7, 20),
    totalPrice: 240.50,
    status: "Processing",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "10",
    orderNumber: "ORD1010",
    customerName: "Charlotte Martin",
    orderDate: DateTime(2026, 7, 20),
    totalPrice: 780.30,
    status: "Delivered",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "11",
    orderNumber: "ORD1011",
    customerName: "Benjamin Clark",
    orderDate: DateTime(2026, 7, 21),
    totalPrice: 155.90,
    status: "Pending",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "12",
    orderNumber: "ORD1012",
    customerName: "Amelia Walker",
    orderDate: DateTime(2026, 7, 21),
    totalPrice: 620.00,
    status: "Delivered",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "13",
    orderNumber: "ORD1013",
    customerName: "Daniel Hall",
    orderDate: DateTime(2026, 7, 22),
    totalPrice: 98.99,
    status: "Processing",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "14",
    orderNumber: "ORD1014",
    customerName: "Mia Allen",
    orderDate: DateTime(2026, 7, 22),
    totalPrice: 412.49,
    status: "Pending",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "15",
    orderNumber: "ORD1015",
    customerName: "Ethan Young",
    orderDate: DateTime(2026, 7, 23),
    totalPrice: 275.25,
    status: "Cancelled",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "16",
    orderNumber: "ORD1016",
    customerName: "Harper King",
    orderDate: DateTime(2026, 7, 23),
    totalPrice: 845.60,
    status: "Delivered",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "17",
    orderNumber: "ORD1017",
    customerName: "Logan Scott",
    orderDate: DateTime(2026, 7, 24),
    totalPrice: 134.75,
    status: "Pending",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "18",
    orderNumber: "ORD1018",
    customerName: "Grace Green",
    orderDate: DateTime(2026, 7, 24),
    totalPrice: 390.10,
    status: "Processing",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "19",
    orderNumber: "ORD1019",
    customerName: "Henry Adams",
    orderDate: DateTime(2026, 7, 25),
    totalPrice: 560.40,
    status: "Delivered",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  OrderModel(
    id: "20",
    orderNumber: "ORD1020",
    customerName: "Lily Carter",
    orderDate: DateTime(2026, 7, 25),
    totalPrice: 220.15,
    status: "Pending",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];