import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/auth_controller/auth_controller.dart';
import 'package:maneger/controller/talabat_controller/cart_controllerw.dart';
import 'package:maneger/controller/talabat_controller/profile_controller.dart';
import 'package:maneger/controller/talabat_controller/tal_map_controller.dart';
import 'package:maneger/model/user_model.dart';
import 'package:maneger/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';

class CheckoutController extends GetxController {
  //////////////
  // أضف هذا السطر مع الـ controllers الأخرى
  final TalMapController mapController = Get.find<TalMapController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final isLoading = false.obs;
  final ismap = false.obs;
  final RxBool isEditing = false.obs;

  late RxDouble selectedLat = 0.0.obs;
  late RxDouble selectedLong = 0.0.obs;
  // لتخزين الإحداثيات المختارة
  // double get selectedLat => mapController.destinationLatLng.value.latitude;
  // double get selectedLong => mapController.destinationLatLng.value.longitude;
  /////////
  final Crud _crud = Crud();
  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();
  // final Rx<User?> user = Rx<User?>(null);
  Rx<User?> get user => profileController.user;

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  // Observable variables
  final RxString selectedPaymentMethod = 'cash'.obs;
  final RxBool isProcessing = false.obs;
  final statusRequest = StatusRequest.loading.obs;

  // Shipping cost
  final RxDouble shippingCost = 5.0.obs;

  @override
  void onInit() async {
    super.onInit();
    loadUserData();
    await _loadFromStorage();
  }

  @override
  void onReady() {
    profileController.user.listen((user) {
      if (user != null) {
        _fillFormControllers();
      }
    });

    super.onReady();
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
    if (user.value != null) {
      nameController.text = user.value!.userName;
      phoneController.text = user.value!.userPhone ?? '';
      addressController.text = user.value!.userAddress ?? '';
      // cityController.text = user.value!.userCity ?? '';
      // countryController.text = user.value!.userCountry ?? '';
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
    // final user = authController.currentUser.value;
    // if (user != null) {
    //   nameController.text = user.userName;
    //   phoneController.text = user.userPhone ?? '';
    //   addressController.text = user.userAddress ?? '';
    // }
    // Get the latest coordinates directly from the Map Controller
    selectedLat.value = mapController.destinationLatLng.value.latitude;
    selectedLong.value = mapController.destinationLatLng.value.longitude;
  }

  // void _syncInitialSelectedCount() {
  //   selectedCount.value = products.where((p) => p.isSelected).length;
  //   selectAll.value =
  //       products.isNotEmpty && products.every((p) => p.isSelected);
  // }
  Future<void> _loadFromStorage() async {
    ismap.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString('location');

      if (raw == null || raw.isEmpty) return;

      // 1. Decode the JSON string back into a Map
      final Map<String, dynamic> locationData = jsonDecode(raw);

      // 2. Assign values to your Rx variables
      if (locationData.containsKey('lat') && locationData.containsKey('lng')) {
        selectedLat.value = locationData['lat'];
        selectedLong.value = locationData['lng'];

        print(
          "📍 Location loaded: ${selectedLat.value}, ${selectedLong.value}",
        );
      }
    } catch (e) {
      print("⚠️ Error decoding location from storage: $e");
      // Default values in case of corruption
      selectedLat.value = 0.0;
      selectedLong.value = 0.0;
    }
    ismap.value = false;
  }

  // Calculate totals
  double get subtotal => cartController.subtotal;
  // double get tax => cartController.tax;
  double get shipping => shippingCost.value;
  double get total => subtotal + shipping;

  // Select payment method
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Validate form
  bool validateForm() {
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
    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'العنوان مطلوب',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
    // if (cityController.text.trim().isEmpty) {
    //   Get.snackbar(
    //     'Error',
    //     'Please enter your city',
    //     backgroundColor: Colors.red.shade100,
    //   );
    //   return false;
    // }
    // if (countryController.text.trim().isEmpty) {
    //   Get.snackbar(
    //     'Error',
    //     'Please enter your country',
    //     backgroundColor: Colors.red.shade100,
    //   );
    //   return false;
    // }
    return true;
  }

  // Place order
  Future<void> placeOrder() async {
    if (!validateForm()) return;

    if (cartController.products.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty');
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

      // استخراج الـ IDs الفريدة
      final vendorIdsList = cartController.products
          .where((product) => product.vendorId != null) // تأكد أن الـ ID موجود
          .map((product) => product.vendorId.toString())
          .toSet() // لحذف التكرار
          .toList(); // تحويلها لـ "1,2,5"
      print(vendorIdsList);
      // Prepare order data
      final orderData = {
        'action': 'create_order',
        'user_id':
            authController.userId ?? '9', // Default to 1 if not logged in
        'vendor_id': vendorIdsList.join(','),

        /// how to get all venders id for checkout
        'total': total.toStringAsFixed(2),

        'subtotal': subtotal.toStringAsFixed(2),
        // 'tax': tax.toStringAsFixed(2),
        'shipping': shipping.toStringAsFixed(2),

        'delivery_name': nameController.text.trim(),
        'delivery_phone': phoneController.text.trim(),
        'delivery_address': addressController.text.trim(),
        'lat': selectedLat.value.toString(),
        'long': selectedLong.value.toString(),
        'order_notes': notesController.text.trim(),
        'order_items': jsonEncode(orderItems),
      };

      // Send request to API

      // print((authController.userId).runtimeType);

      final response = await _crud.postData(ApiConstants.orders, orderData);
      print(response);
      response.fold(
        (statusReq) {
          // Error
          statusRequest.value = statusReq;
          isProcessing.value = false;
          Get.snackbar('Error', 'Failed to place order. Please try again.');
        },
        (responseBody) {
          print(responseBody);
          // Success
          isProcessing.value = false;
          statusRequest.value = StatusRequest.success;

          if (responseBody['status'] == 'success') {
            final orderId = responseBody['order_id'].toString();

            // Unfocus keyboard to prevent platform NPE during transition
            FocusManager.instance.primaryFocus?.unfocus();

            // Clear cart
            cartController.products.clear();

            // Navigate to confirmation screen
            Get.offNamed(
              AppRoutes.orderConfirmation,
              arguments: {'order_id': orderId, 'total': total},
            );
          } else {
            print(responseBody['message']);
            Get.snackbar(
              'Error',
              responseBody['message'] ?? 'Failed to place order',
            );
          }
        },
      );
    } catch (e) {
      print(e);
      isProcessing.value = false;
      statusRequest.value = StatusRequest.serverfailure;
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  void openMap() {
    Get.toNamed(AppRoutes.mapScreen);
  }
}
