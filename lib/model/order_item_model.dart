class OrderItemModel {
  final String id;
  final String orderId;
  final String productName;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  OrderItemModel copyWith({
    String? id,
    String? orderId,
    String? productName,
    int? quantity,
    double? price,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}