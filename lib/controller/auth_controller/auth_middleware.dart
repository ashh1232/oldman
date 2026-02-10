import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final prefs = Get.find<SharedPreferences>(); // إذا قمت بحقنها في الـ main

    String? token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      return null; // مسجل دخول، استمر للصفحة المطلوبة
    } else {
      return const RouteSettings(name: '/login'); // غير مسجل، ارجع للـ login
    }
  }
}
