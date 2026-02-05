class Product {
  final String id;
  final String vendorId;

  final String title;
  final String price;
  final String image;
  final String categoryId;
  final String originalPrice;
  final String description;
  final String blurHash; // الحقل الجديد
  String catName;
  bool isSelected;
  int quantity;
  final int? productDiscount;
  final int? stockQuantity;

  // final int? productId;
  // final String? productName;
  // final double? productPrice;
  // final String? productImage;
  // final String? productBlurhash;
  // final int? productCat;
  // final String? productDescription;
  // final int? categoriesId;
  // final String? categoriesName;
  // final String? categoriesImage;
  // final String? categoriesBlurhash;
  // final int? catMain;
  Product({
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.id,
    required this.title,
    required this.image,
    required this.categoryId,
    required this.blurHash, // مطلوب في الـ Constructor
    this.isSelected = true,
    this.quantity = 1,
    this.catName = '1',
    required this.vendorId,
    this.productDiscount,
    this.stockQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? json['product_id'] ?? "0").toString(),
      vendorId: (json['vendor_id'] ?? "0").toString(),

      title: (json['title'] ?? json['product_name'] ?? "بدون عنوان").toString(),
      price: (json['price'] ?? json['product_price'] ?? "0").toString(),
      image:
          (json['image'] ??
                  json['product_image'] ??
                  "https://iraq.talabat.com/assets/images/header_image-EN.png")
              .toString(),
      categoryId: (json['categoryId'] ?? json['product_cat'] ?? "1").toString(),
      originalPrice: (json['originalPrice'] ?? json['original_price'] ?? "0.0")
          .toString(),
      description: (json['description'] ?? json['product_desc'] ?? "بدون وصف")
          .toString(),

      // استقبال الـ BlurHash من السيرفر (تأكد من مطابقة الاسم مع عمود قاعدة البيانات)
      blurHash:
          (json['product_blurhash'] ?? "UBEVsa9E0M~q~T%ND%x^01-:wbITt8t6%hxa")
              .toString(),
      productDiscount: json['product_discount'],
      stockQuantity: json['stock_quantity'],

      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? "1") ?? 1,
      catName: (json['cat_name'] ?? json['categories_name'] ?? "بدون عنوان")
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id, // نستخدم الاسم المتوقع في الـ Backend
      'vendor_id': vendorId,
      'product_name': title,
      'product_desc': description,
      'product_image': image,
      'product_price': price,
      'quantity': quantity,
      'product_blurhash': blurHash,
    };
  }

  double get totalPrice {
    try {
      return (double.tryParse(price) ?? 0) * quantity;
    } catch (e) {
      return 0;
    }
  }
}
// class Product {
//   final int? productId;
//   final int? vendorId;
//   final String? productName;
//   final double? productPrice;
//   final String? productImage;
//   final String? productBlurhash;
//   final int? productCat;
//   final int? productDiscount;
//   final String? productDescription;
//   final int? stockQuantity;
//   final int? categoriesId;
//   final String? categoriesName;
//   final String? categoriesImage;
//   final String? categoriesBlurhash;
//   final int? catMain;

//   Product({
//     this.productId,
//     this.vendorId,
//     this.productName,
//     this.productPrice,
//     this.productImage,
//     this.productBlurhash,
//     this.productCat,
//     this.productDiscount,
//     this.productDescription,
//     this.stockQuantity,
//     this.categoriesId,
//     this.categoriesName,
//     this.categoriesImage,
//     this.categoriesBlurhash,
//     this.catMain,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productId: json['product_id'],
//       productName: json['product_name'],
//       productPrice: json['product_price']?.toDouble(),
//       productImage: json['product_image'],
//       productBlurhash: json['product_blurhash'],
//       productCat: json['product_cat'],
//       productDescription: json['product_description'],
//       categoriesId: json['categories_id'],
//       categoriesName: json['categories_name'],
//       categoriesImage: json['categories_image'],
//       categoriesBlurhash: json['categories_blurhash'],
//       catMain: json['cat_main'],
//     );
//   }

//   static List<Product> fromList(List<dynamic> list) {
//     return list.map((item) => Product.fromJson(item)).toList();
//   }
// }
