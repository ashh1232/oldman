import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/order_model.dart';

class DeliveryHomeController extends GetxController {
  // Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;
  final Crud _crud = Crud();
  var isLoading = false.obs;
  final RxList<Order> orders = <Order>[].obs;
  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  var currentIndex = 0.obs;
  @override
  void onReady() {
    super.onReady();
    getOrders(); // انقل استدعاء البيانات إلى هنا
  }

  Future<void> getOrders() async {
    if (isLoading.value) return;
    // statusRequest.value = StatusRequest.loading;

    try {
      isLoading.value = true;
      var respo = await _crud.postData(ApiConstants.adminOrder, {
        'action': 'get_processing_order',
      });
      respo.fold(
        (status) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.context != null && !Get.isSnackbarOpen) {
              Get.rawSnackbar(
                message: "خطأ في التحميل: $status",
                duration: Duration(seconds: 2),
              );
            }
          });
        },
        (res) {
          if (res['status'] == 'success') {
            final List decod = res['data'];
            orders.value = decod.map((ban) => Order.fromJson(ban)).toList();
          } else {}
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
    } finally {
      isLoading.value = false;
    }
  }

  void removeProduct(int index) {
    orders.removeAt(index);
  }
}
