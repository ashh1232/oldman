class OrderProductsModel {
  final int? itemId;
  final int? orderId;
  final int? productId;
  final String? productName;
  final String? productImage;
  final double? productPrice;
  final int? itemQuantity;
  final double? itemTotal;
  final DateTime? createdAt;

  OrderProductsModel({
    this.itemId,
    this.orderId,
    this.productId,
    this.productName,
    this.productImage,
    this.productPrice,
    this.itemQuantity,
    this.itemTotal,
    this.createdAt,
  });

  factory OrderProductsModel.fromJson(Map<String, dynamic> json) {
    return OrderProductsModel(
      itemId: json['item_id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      productPrice: json['product_price'] != null
          ? double.tryParse(json['product_price'].toString())
          : null,
      itemQuantity: json['item_quantity'],
      itemTotal: json['item_total'] != null
          ? double.tryParse(json['item_total'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'product_price': productPrice,
      'item_quantity': itemQuantity,
      'item_total': itemTotal,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
