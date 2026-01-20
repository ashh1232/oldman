import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // التحقق مما إذا كان الوضع الداكن مفعلاً في الإعدادات
  bool isDark() => _box.read(_key) ?? false;

  // الحصول على الثيم المناسب عند تشغيل التطبيق
  ThemeMode get theme => isDark() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    // 1. تغيير الثيم في الواجهة فوراً
    Get.changeThemeMode(isDark() ? ThemeMode.light : ThemeMode.dark);

    // 2. حفظ الحالة الجديدة في الذاكرة المستديمة
    _saveThemeToBox(!isDark());
  }

  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
}
