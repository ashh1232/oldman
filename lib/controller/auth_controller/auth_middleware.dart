import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/auth_controller/storage_service.dart'; // تأكد من المسار الصحيح

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // استخدم الـ Service التي قمت بحقنها بدلاً من SharedPreferences
    final storage = Get.find<StorageService>();

    // الوصول للـ token من خلال prefs الموجودة داخل storage
    String? token = storage.prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      return null; // استمر للصفحة
    } else {
      return const RouteSettings(name: '/login'); // اذهب لتسجيل الدخول
    }
  }
}
