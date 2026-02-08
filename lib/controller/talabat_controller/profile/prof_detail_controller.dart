import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/order_del_model.dart';

class ProfileOrderDetailController extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;
  final Crud _crud = Crud();
  var isLoading = false.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  var currentIndex = 0.obs;
  @override
  void onReady() {
    getOrders(); // انقل استدعاء البيانات إلى هنا
    super.onReady();
  }

  Future<void> getOrders() async {
    print('object');
    if (isLoading.value) return;
    statusRequest.value = StatusRequest.loading;

    try {
      isLoading.value = true;
      var respo = await _crud.postData(ApiConstants.orders, {
        'action': 'get_order_details',
        'order_id': '18',
      });
      print(respo);
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
            statusRequest.value = StatusRequest.success;
            print(res['data']);
            //////////////
            final Map<String, dynamic> orderData = res['data'];
            final List<dynamic> items = orderData['items'];
            // final List<dynamic> decod = res['data'];
            print(orderData);
            // orders.value = orderData
            //     .map((ban) => OrderModel.fromJson(ban))
            //     .toList();
            orders.value = [OrderModel.fromJson(res['data'])];
          } else {
            statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
      statusRequest.value = StatusRequest.failure;
    }
    isLoading.value = false;
  }

  void updateQuantity(int index, int quantity) {
    // product[index].quantity = quantity;
  }

  void removeProduct(int index) {
    orders.removeAt(index);
  }
}
