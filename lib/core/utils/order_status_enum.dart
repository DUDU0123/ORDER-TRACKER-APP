enum OrderStatusEnum {
  pending,
  processing,
  delivered,
  cancelled,
}

extension OrderStatusExtension on String {
  OrderStatusEnum toOrderStatus() {
    switch (toLowerCase()) {
      case 'pending':
        return OrderStatusEnum.pending;
      case 'processing':
        return OrderStatusEnum.processing;
      case 'delivered':
        return OrderStatusEnum.delivered;
      case 'cancelled':
        return OrderStatusEnum.cancelled;
      default:
        return OrderStatusEnum.processing;
    }
  }
}