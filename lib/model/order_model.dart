class Order {
  final String orderId;
  final String userId;
  final String orderTotal;
  final String orderSubtotal;
  final String orderShipping;
  final String orderStatus;
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryAddress;
  final String deliveryLat;
  final String deliveryLong;
  final String paymentStatus;
  final String orderNotes;
  final String createdAt;
  final String updatedAt;

  Order({
    required this.orderId,
    required this.userId,
    required this.orderTotal,
    required this.orderSubtotal,
    required this.orderShipping,
    required this.orderStatus,
    required this.deliveryName,
    required this.deliveryPhone,
    required this.deliveryAddress,
    required this.deliveryLat,
    required this.deliveryLong,
    required this.paymentStatus,
    required this.orderNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  // تحويل JSON القادم من الـ API إلى Object
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: (json['order_id'] ?? "0").toString(),
      userId: (json['user_id'] ?? "0").toString(),
      orderTotal: (json['order_total'] ?? "0").toString(),
      orderSubtotal: (json['order_subtotal'] ?? "0").toString(),
      orderShipping: (json['order_shipping'] ?? "0").toString(),
      orderStatus: (json['order_status'] ?? "0").toString(),
      deliveryName: (json['delivery_name'] ?? "0").toString(),
      deliveryPhone: (json['delivery_phone'] ?? "0").toString(),
      deliveryAddress: (json['delivery_address'] ?? "0").toString(),
      deliveryLat: (json['delivery_lat'] ?? "0").toString(),
      deliveryLong: (json['delivery_long'] ?? "0").toString(),
      paymentStatus: (json['payment_status'] ?? "0").toString(),
      orderNotes: (json['order_notes'] ?? "0").toString(),
      createdAt: (json['created_at'] ?? "0").toString(),
      updatedAt: (json['updated_at'] ?? "0").toString(),
    );
  }

  // تحويل الـ Object إلى JSON لإرساله للسيرفر
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'order_total': orderTotal,
      'order_subtotal': orderSubtotal,
      'order_shipping': orderShipping,
      'order_status': orderStatus,
      'delivery_name': deliveryName,
      'delivery_phone': deliveryPhone,
      'delivery_address': deliveryAddress,
      'delivery_lat': deliveryLat,
      'delivery_long': deliveryLong,
      'payment_status': paymentStatus,
      'order_notes': orderNotes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
