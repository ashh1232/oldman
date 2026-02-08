import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/auth_controller/auth_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/order_model.dart';
import 'package:maneger/model/user_model.dart';

import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // Add this as a static member
  static final RegExp _phoneRegex = RegExp(r'''
    ^(970|00970|\+970)[23489]\d{7}$|
    ^(972|00972|\+972)5[0234589]\d{7}$|
    ^0?[23489]\d{7}$|
    ^0?5[0234589]\d{7}$
  ''', caseSensitive: false);
  final Crud _crud = Crud();
  final AuthController authController = Get.find<AuthController>();

  // Observable variables
  Rx<User?> get user => authController.currentUser;
  final RxList<Order> orders = <Order>[].obs;
  final statusRequest = StatusRequest.loading.obs;
  final RxBool isEditing = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Use 'ever' to react when the user is restored or changed
    ever(authController.currentUser, (User? user) {
      if (user != null && statusRequest.value == StatusRequest.loading) {
        loadProfile();
        loadOrders();
      }
    });

    // If user is already loaded (e.g. just logged in), run immediately
    if (authController.userId != null) {
      loadProfile();
      loadOrders();
    } else {
      // If we are waiting for restoration, maybe show a loading state
      // checkLoginStatus is async and might still be running
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.onClose();
  }

  // Load user profile
  Future<void> loadProfile() async {
    statusRequest.value = StatusRequest.loading;
    try {
      final userId = authController.userId;
      if (userId == null) {
        statusRequest.value = StatusRequest.failure;
        return;
      }

      final response = await _crud.postData(ApiConstants.profile, {
        'action': 'get_profile',
        'user_id': userId,
      });
      response.fold(
        (statusReq) {
          statusRequest.value = statusReq;
        },
        (responseBody) {
          if (responseBody['status'] == 'success') {
            user.value = User.fromJson(responseBody['data']);
            _fillFormControllers();
            statusRequest.value = StatusRequest.success;
          } else {
            statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      statusRequest.value = StatusRequest.serverfailure;
    }
  }

  bool _validateInput() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'اسم المستخدم مطلوب',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }

    if (nameController.text.trim().length < 2) {
      Get.snackbar(
        'خطأ',
        'يجب أن يكون اسم المستخدم أكثر من حرفين',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'رقم الهاتف مطلوب',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }

    // Add phone number format validation
    if (!_isValidPhone(phoneController.text.trim())) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال رقم هاتف صحيح',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }

    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'العنوان مطلوب',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }

    if (addressController.text.trim().length < 3) {
      Get.snackbar(
        'خطأ',
        'يجب أن يكون العنوان أكثر من 5 أحرف',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }

    return true;
  }

  // Phone number validation
  bool _isValidPhone(String phone) {
    // Supports Palestinian (970), Israeli (972), or Jordanian (962) formats
    final pattern = RegExp(
      r'^(00970|\+970|0)?5[0-9]{8}$|^(\+972|0)[23489]\d{7}$|^(\+962|0)7[789]\d{7}$',
    );
    return pattern.hasMatch(phone.replaceAll(RegExp(r'\s+'), ''));
  }

  // Helper method to validate phone number format
  // bool isValidPhoneNumber(String phone) {
  //   // Clean the input first
  //   String cleanPhone = phone.replaceAll(RegExp(r'[ -]'), '');

  //   return _phoneRegex.hasMatch(cleanPhone);
  // }

  // Fill form controllers with user data
  void _fillFormControllers() {
    if (user.value != null) {
      nameController.text = user.value!.userName;
      phoneController.text = user.value!.userPhone ?? '';
      addressController.text = user.value!.userAddress ?? '';
      // cityController.text = user.value!.userCity ?? '';
      // countryController.text = user.value!.userCountry ?? '';
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      _fillFormControllers(); // Reset form if canceling edit
    }
  }

  // Update profile
  // Update profile
  Future<void> updateProfile() async {
    if (!_validateInput()) return;

    statusRequest.value = StatusRequest.loading;

    try {
      final userId = authController.userId;
      if (userId == null) {
        Get.snackbar(
          'خطأ',
          'لم يتم العثور على معلومات المستخدم',
          backgroundColor: Colors.red.shade100,
        );
        statusRequest.value = StatusRequest.failure;
        return;
      }

      final response = await _crud.postData(ApiConstants.profile, {
        'action': 'update_profile',
        'user_id': user.value!.userId.toString(),
        'user_name': nameController.text.trim(),
        'user_phone': phoneController.text.trim(),
        'user_address': addressController.text.trim(),
        // 'user_city': cityController.text.trim(),
        // 'user_country': countryController.text.trim(),
      });

      response.fold(
        (statusReq) {
          statusRequest.value = statusReq;
          Get.snackbar(
            'خطأ',
            'فشل تحديث الملف الشخصي',
            backgroundColor: Colors.red.shade100,
          );
        },
        (responseBody) {
          if (responseBody['status'] == 'success') {
            Get.snackbar(
              'نجاح',
              'تم تحديث الملف الشخصي بنجاح',
              backgroundColor: Colors.green.shade100,
            );
            loadProfile(); // Reload profile to reflect changes
            isEditing.value = false; // Exit edit mode
            statusRequest.value = StatusRequest.success;
          } else {
            Get.snackbar(
              'خطأ',
              responseBody['message'] ?? 'فشل التحديث',
              backgroundColor: Colors.red.shade100,
            );
            statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      statusRequest.value = StatusRequest.serverfailure;
      Get.snackbar('خطأ', 'حدث خطأ: $e', backgroundColor: Colors.red.shade100);
    }
  }

  // Load user orders
  Future<void> loadOrders() async {
    try {
      final userId = authController.userId;
      if (userId == null) return;

      final response = await _crud.postData(ApiConstants.orders, {
        'action': 'get_orders',
        'user_id': userId,
      });

      response.fold(
        (statusReq) {
          // Handle error silently for orders
        },
        (responseBody) {
          if (responseBody['status'] == 'success') {
            final List<dynamic> data = responseBody['data'];
            orders.value = data.map((json) => Order.fromJson(json)).toList();
          }
        },
      );
    } catch (e) {
      // Handle error silently
    }
  }

  // Logout
  void logout() {
    authController.logout();
  }
}
