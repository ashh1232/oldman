import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late SharedPreferences prefs;

  Future<StorageService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  // دالة للتأكد من حالة الدخول
  bool isLoggedIn() {
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
