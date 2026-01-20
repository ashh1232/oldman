import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/model/order_model.dart' show Order;
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/order_products_model.dart';

class AdminProOrderController extends GetxController {
  final Order item = Get.arguments;
  RxList<OrderProductsModel> ordersProduct = <OrderProductsModel>[].obs;
  RxBool isLoading = false.obs;

  final Crud _crud = Crud();
  Future<void> getOrdersProduct() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      var respo = await _crud.postData(AppLink.adminOrderProduct, {
        'order_id': item.orderId,
      });
      // print(respo);
      print('respo');
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
            print(' decod $decod');

            ordersProduct.value = decod
                .map((ban) => OrderProductsModel.fromJson(ban))
                .toList();
            // print('orders $orders');
            print('ordersProduct $ordersProduct');
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

  Future<void> updateOrderStatus() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      var respo = await _crud.postData(AppLink.adminOrderProduct, {
        'order_id': item.orderId,
      });
      // print(respo);
      print('respo');
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
            print(' decod $decod');

            ordersProduct.value = decod
                .map((ban) => OrderProductsModel.fromJson(ban))
                .toList();
            // print('orders $orders');
            print('ordersProduct $ordersProduct');
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    getOrdersProduct();

    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
