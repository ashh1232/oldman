import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/core/constants/api_constants.dart';
// import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/order_model.dart';

class AdminOrderProcessController extends GetxController {
  final Rx<StatusRequest> statusRequest = StatusRequest.loading.obs;

  final Crud _crud = Crud();
  var isLoading = false.obs;
  final RxList<Order> orders = <Order>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

  var currentIndex = 0.obs;
  @override
  void onReady() {
    super.onReady();
    getOrdersProcess(); // انقل استدعاء البيانات إلى هنا
  }

  Future<void> getOrdersProcess() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      var response = await _crud.postData(ApiConstants.adminOrder, {
        'action': 'get_processing_order',
      });
      response.fold((status) => _handleError(status, "فشل تحميل الإعلانات"), (
        res,
      ) {
        if (res['status'] == 'success') {
          final List decod = res['data'];
          orders.assignAll(decod.map((ban) => Order.fromJson(ban)).toList());
        }
      });
    } catch (e) {
      _handleError(StatusRequest.serverfailure, "خطأ غير متوقع");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(StatusRequest status, String message) {
    if (status == StatusRequest.offline) {
      _showErrorSnackbar("أنت غير متصل بالإنترنت");
    } else {
      _showErrorSnackbar(message);
    }
  }

  void _showErrorSnackbar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isSnackbarOpen) {
        Get.rawSnackbar(
          message: message,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.black87,
        );
      }
    });
  }
  // Future<void> getOrders() async {
  //   if (isLoading.value) return;
  //   // statusRequest.value = StatusRequest.loading;

  //   try {
  //     isLoading.value = true;
  //     var respo = await _crud.postData(AppLink.adminOrder, {
  //       'action': 'get_process_order',
  //       // 'user_id': '2',
  //     });
  //     // print(respo);
  //     respo.fold(
  //       (status) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           if (Get.context != null && !Get.isSnackbarOpen) {
  //             Get.rawSnackbar(
  //               message: "خطأ في التحميل: $status",
  //               duration: Duration(seconds: 2),
  //             );
  //           }
  //         });
  //       },
  //       (res) {
  //         if (res['status'] == 'success') {
  //           // print(res['data']);
  //           // statusRequest.value = StatusRequest.success;
  //           final List decod = res['data'];
  //           // print(' decod $decod');

  //           orders.value = decod.map((ban) => Order.fromJson(ban)).toList();
  //           // print('orders $orders');
  //           print('respo');
  //         } else {
  //           // statusRequest.value = StatusRequest.failure;
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     Get.snackbar(('error'), 'error $e');
  //     // fistatusRequest.value = StatusRequest.failure;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void updateQuantity(int index, int quantity) {
    // product[index].quantity = quantity;
  }

  void removeProduct(int index) {
    orders.removeAt(index);
  }
}
