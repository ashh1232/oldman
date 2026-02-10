class User {
  final String userId;
  final String userName;
  final String? userEmail;
  final String userPhone;
  final String? userImage;
  final String? userAddress;
  final String userType;
  // final String? userCity;
  // final String? userCountry;
  final String? createdAt;

  User({
    required this.userId,
    required this.userName,
    this.userEmail,
    required this.userPhone,
    this.userImage,
    this.userAddress,
    // this.userCity,
    // this.userCountry,
    this.createdAt,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // تحويل آمن للـ ID حتى لو جاء كـ int أو String
      userId: json['user_id']?.toString() ?? '',

      // تجنب 'as String' واستخدم ?? لتوفير قيمة افتراضية في حال كان null
      userName: json['user_name']?.toString() ?? 'Unknown',

      userPhone: json['user_phone']?.toString() ?? '',

      // الحقول التي تسمح بـ null (Optional) لا تستخدم معها 'as String'
      userImage: json['user_image']?.toString(),
      userAddress: json['user_address']?.toString(),

      createdAt: json['created_at']?.toString(),

      // التأكد من جلب الرتبة بشكل صحيح
      userType: json['user_role']?.toString() ?? 'clint',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
      'user_image': userImage,
      'user_address': userAddress,
      // 'user_city': userCity,
      // 'user_country': userCountry,
      'user_role': userType,
    };
  }

  // Helper method to get full image URL
  String? get fullImageUrl {
    if (userImage == null || userImage!.isEmpty) return null;
    // Assuming your server URL from linkapi.dart
    if (userImage!.startsWith('http')) return userImage;
    return 'http://192.168.0.154/$userImage';
  }

  // Helper method to get display name
  String get displayName => userName.isNotEmpty ? userName : userPhone;
}
