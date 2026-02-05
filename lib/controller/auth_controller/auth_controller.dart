import 'dart:convert';

import 'package:get/get.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/user_model.dart';
import 'package:maneger/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/linkapi.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);

  final Crud crud = Crud();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;

  late StatusRequest statusRequest;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userStr = prefs.getString('current_user');

    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      if (userStr != null) {
        try {
          currentUser.value = User.fromJson(jsonDecode(userStr));
        } catch (e) {
          Get.snackbar('Error', 'Failed to save user data');
        }
      }
    } else {
      isLoggedIn.value = false;
    }
  }

  Future<void> login(String phone, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    print(phone);
    print(password);
    final response = await crud.postData(ApiConstants.login, {
      'phone': phone,
      'password': password,
    });
    print(response);
    response.fold(
      (failure) {
        errorMessage.value = 'Login failed. Please try again.';
      },
      (data) async {
        if (data['status'] == 'success') {
          final token = data['data']['token'];
          // Use data['data'] directly if that's where the user info is,
          // or data['data']['user'] if structured that way.
          // Based on typical PHP CRUD structures:
          final userData = data['data'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          if (userData != null) {
            await saveUserData(User.fromJson(userData));
          }

          isLoggedIn.value = true;
          Get.offAllNamed('/home');
        } else {
          errorMessage.value = data['message'] ?? 'Invalid credentials';
          Get.snackbar('Login Status', 'Failed');
        }
      },
    );

    isLoading.value = false;
  }

  Future<void> signup(String username, String phone, String password) async {
    print(username);
    print(phone);
    print(password);
    try {
      statusRequest = StatusRequest.loading;
      isLoading.value = true;

      final response = await crud.postData(ApiConstants.signup, {
        'username': username,
        // 'email': email,
        'password': password,
        'phone': phone,
      });
      print(response);
      // var yy = response.fold((l) => l, (r) => r);
      // statusRequest = handlingData(yy);
      response.fold(
        (failure) {
          // في حال فشل الاتصال أو السيرفر (Left)
          statusRequest = failure; // مثل serverfailure أو offline
          errorMessage.value = 'مشكلة في الاتصال بالسيرفر';
          Get.snackbar('خطأ', 'فشل الاتصال بالشبكة');
          // statusRequest = failure;
          // Get.snackbar('خطأ', 'فشل الاتصال بالشبكة ${failure['message']}');
        },
        (data) async {
          print(data['message']);
          if (data['status'] == 'success') {
            final token = data['data']['token'];
            final userData = data['data'];

            final prefs = await SharedPreferences.getInstance();
            if (token != null) {
              await prefs.setString('auth_token', token);
            }

            if (userData != null) {
              await saveUserData(User.fromJson(userData));
            }

            isLoggedIn.value = true;
            Get.offAllNamed(AppRoutes.home);
          } else {
            errorMessage.value = data['message'] ?? 'Signup failed';
            Get.snackbar('خطأ', ' ${data['message']}');
          }
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to save user data $e');
    }
    isLoading.value = false;
  }

  // Save user data after login
  Future<void> saveUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', jsonEncode(user.toJson()));
      currentUser.value = user;
      isLoggedIn.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to save user data');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('current_user');
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  String? get userId => currentUser.value?.userId;

  // Update current user
  void updateUser(User user) {
    currentUser.value = user;
    saveUserData(user);
  }
}
