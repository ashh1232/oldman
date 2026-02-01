import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/core/constants/api_constants.dart';
// import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/model/order_model.dart';

class VendorOrderController extends GetxController {
  final Crud _crud = Crud();
  var isLoading = false.obs;
  final RxList<Order> orders = <Order>[].obs;
  @override
  void onInit() {
    // Moved getOrders to onReady for better visibility
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
        'action': 'get_pending_order',
        // 'user_id': '2',
      });
      // print(respo);
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
            // print(res['data']);
            // statusRequest.value = StatusRequest.success;
            final List decod = res['data'];
            // print(' decod $decod');

            orders.value = decod.map((ban) => Order.fromJson(ban)).toList();
          } else {
            // statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
      // fistatusRequest.value = StatusRequest.failure;
    } finally {
      isLoading.value = false;
    }
  }

  void removeProduct(int index) {
    orders.removeAt(index);
  }
}
