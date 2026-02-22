import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/auth_controller/auth_controller.dart';
import 'package:maneger/controller/talabat_controller/cart_controllerw.dart';
import 'package:maneger/controller/talabat_controller/profile/profile_controller.dart';
import 'package:maneger/controller/talabat_controller/tal_map_controller.dart';
import 'package:maneger/model/user_model.dart';
import 'package:maneger/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';

class CheckoutController extends GetxController {
  // Controllers

  final TalMapController mapController = Get.find<TalMapController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();

  Rx<User?> get user => authController.currentUser;

  // State flags
  final ismap = false.obs;
  final RxBool isEditing = false.obs;
  final Crud _crud = Crud();

  // Location coordinates
  late RxDouble selectedLat = 0.0.obs;
  late RxDouble selectedLong = 0.0.obs;

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  // Observable variables
  final RxBool isProcessing = false.obs;
  final statusRequest =
      StatusRequest.loading.obs; // Changed to loading initially

  // Shipping cost
  final RxDouble shippingCost = 5.0.obs;

  // Computed properties
  double get subtotal => cartController.subtotal;
  double get shipping => shippingCost.value;
  double get total => subtotal + shipping;

  User? get currentUser => profileController.user.value;

  // @override
  // void onInit() {
  //   super.onInit();

  //   // Listen to user changes
  // }

  @override
  void onReady() {
    ever(profileController.user, (_) => _fillFormControllers());

    // Initialize data after controller setup
    Future.microtask(() {
      loadUserData();
      _loadFromStorage();
      statusRequest.value = StatusRequest.success; // Set to success after init
    });
    super.onReady();
    // Additional setup if needed
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.onClose();
  }

  // Fill form controllers with user data
  void _fillFormControllers() {
    if (currentUser != null) {
      nameController.text = currentUser!.userName;
      phoneController.text = currentUser!.userPhone;
      addressController.text = currentUser!.userAddress ?? '';
    }
  }

  void toggleEditMode() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      _fillFormControllers(); // Reset form if canceling edit
    }
  }

  // Load user data to pre-fill form
  void loadUserData() {
    _syncCoordinatesFromMap();
  }

  void _syncCoordinatesFromMap() {
    selectedLat.value = mapController.destinationLatLng.value.latitude;
    selectedLong.value = mapController.destinationLatLng.value.longitude;
  }

  // Load location from shared preferences
  Future<void> _loadFromStorage() async {
    ismap.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString('location');

      if (raw != null && raw.isNotEmpty) {
        final Map<String, dynamic> locationData = jsonDecode(raw);

        if (locationData.containsKey('lat') &&
            locationData.containsKey('lng')) {
          selectedLat.value = locationData['lat'].toDouble();
          selectedLong.value = locationData['lng'].toDouble();

          // print(
          //   "📍 Location loaded: ${selectedLat.value}, ${selectedLong.value}",
          // );
        }
      }
    } catch (e) {
      // print("⚠️ Error decoding location from storage: $e");
      // Keep default 0.0 values if error occurs
    }
    ismap.value = false;
  }

  // Coordinate validation
  bool _isValidCoordinates() {
    return selectedLat.value != 0.0 &&
        selectedLong.value != 0.0 &&
        selectedLat.value.abs() <= 90 &&
        selectedLong.value.abs() <= 180;
  }

  // Phone number validation
  bool _isValidPhone(String phone) {
    // Supports Palestinian (970), Israeli (972), or Jordanian (962) formats
    final pattern = RegExp(
      r'^(00970|\+970|0)?5[0-9]{8}$|^(\+972|0)[23489]\d{7}$|^(\+962|0)7[789]\d{7}$',
    );
    return pattern.hasMatch(phone.replaceAll(RegExp(r'\s+'), ''));
  }

  // Validate form
  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('خطأ', 'الاسم مطلوب', backgroundColor: Colors.red.shade100);
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
    if (!_isValidPhone(phoneController.text.trim())) {
      Get.snackbar(
        'خطأ',
        'رقم هاتف غير صحيح',
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
    if (!_isValidCoordinates()) {
      Get.snackbar(
        'خطأ',
        'الرجاء تحديد موقع التوصيل على الخريطة',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
    return true;
  }

  Future<void> updateProfile() async {
    if (!_validateForm()) return;
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
            profileController
                .loadProfile(); // Reload profile to reflect changes
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

  // Place order
  Future<void> placeOrder() async {
    if (!_validateForm()) return;
    if (cartController.products.isEmpty) {
      Get.snackbar(
        'خطأ',
        'عربة التسوق فارغة',
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    isProcessing.value = true;
    statusRequest.value = StatusRequest.loading;

    try {
      // Prepare order items

      final orderItems = cartController.products.map((product) {
        return {
          'product_id': product.id,
          'vendor_id': product.vendorId,
          'product_name': product.title,
          'product_image': product.image,
          'product_price': product.price,
          'quantity': product.quantity,
        };
      }).toList();
      // Extract unique vendor IDs
      // 2. استخراج الموردين الفريدين بشكل صحيح
      // final vendorIdsSet = cartController.products
      //     .where((p) => p.vendorId != null)
      //     .map((p) => p.vendorId.toString())
      //     .toSet();
      final vendorIdsSet = cartController.products
          .map((p) => p.vendorId.toString())
          .toSet();
      // final vendorIdsSet = cartController.products
      //     .map((p) => p.vendorId)
      //     .whereType<int>() // تجلب فقط الـ ints وتستبعد الـ null تلقائياً
      //     .toSet();
      // Extract unique vendor IDs
      final uniqueVendorsCount = vendorIdsSet.length;

      // 3. تحديد الـ vendor_id الذي سيُرسل للطلب الرئيسي
      // إذا كان هناك أكثر من مورد، نرسل '0' أو '1' (حسب إعدادات السيرفر لديك)
      // وإذا كان مورد واحد، نأخذ قيمته مباشرة.
      // final String finalVendorId = uniqueVendorsCount > 1
      //     ? 'multi' // أو '1' حسب ما يتطلبه الـ API الخاص بك
      //     : (vendorIdsSet.isNotEmpty ? vendorIdsSet.first : '0');

      // print(
      //   'Vendors count: $uniqueVendorsCount, Selected Vendor ID: $finalVendorId',
      // );
      // final vendorIdsList = cartController.products
      //     .where((product) => product.vendorId != null)
      //     .map((product) => product.vendorId.toString())
      //     .toSet()
      //     .toList()
      // .first;
      // print('vendor : $vendorIdsList');

      // Prepare order data
      final orderData = {
        'action': 'create_order',
        'user_id': authController.userId,
        // 'vendor_id': finalVendorId,
        'vendor_id': (vendorIdsSet.isNotEmpty ? vendorIdsSet.first : '0'),
        'total': total.toStringAsFixed(2),
        'subtotal': subtotal.toStringAsFixed(2),
        'shipping': shipping.toStringAsFixed(2),
        'delivery_name': nameController.text.trim(),
        'delivery_phone': phoneController.text.trim(),
        'delivery_address': addressController.text.trim(),
        'lat': selectedLat.value.toString(),
        'long': selectedLong.value.toString(),
        'order_notes': notesController.text.trim(),
        'order_items': jsonEncode(orderItems),
        'vendors': uniqueVendorsCount.toString(),
      };
      // print('orderData');
      // print(orderData);

      final response = await _crud.postData(ApiConstants.orders, orderData);

      response.fold(
        (statusReq) {
          // Error handling
          statusRequest.value = statusReq;
          isProcessing.value = false;
          Get.snackbar(
            'خطأ',
            'فشل في إتمام الطلب. يرجى المحاولة مرة أخرى.',
            backgroundColor: Colors.red.shade100,
          );
        },
        (responseBody) {
          // print(responseBody);
          isProcessing.value = false;
          statusRequest.value = StatusRequest.success;

          if (responseBody['status'] == 'success') {
            final orderId = responseBody['order_id'].toString();

            // Unfocus keyboard
            FocusManager.instance.primaryFocus?.unfocus();

            // Clear cart
            cartController.products.clear();

            // Navigate to confirmation screen
            Get.offNamed(
              AppRoutes.orderConfirmation,
              arguments: {'order_id': orderId, 'total': total},
            );
          } else {
            Get.snackbar(
              'خطأ',
              responseBody['message'] ?? 'فشل في إتمام الطلب',
              backgroundColor: Colors.red.shade100,
            );
          }
        },
      );
    } catch (e) {
      // print('Place Order Error: $e');
      isProcessing.value = false;
      statusRequest.value = StatusRequest.serverfailure;
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إتمام الطلب',
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  void openMap() {
    Get.toNamed(AppRoutes.mapScreen);
  }

  // Fallback for user address coordinates if needed
  // void _syncCoordinatesFromUserAddress() {
  //   // Implement reverse geocoding based on user address if available
  //   // This would require an API call to convert address to coordinates
  // }
}
