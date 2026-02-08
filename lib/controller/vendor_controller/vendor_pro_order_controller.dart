import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/controller/vendor_controller/vendor_order_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/order_model.dart' show Order;
import 'package:maneger/model/order_products_model.dart';

class VendorProOrderController extends GetxController {
  final Order item = Get.arguments;
  late VendorOrderController mainController;

  RxList<OrderProductsModel> ordersProduct = <OrderProductsModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // التأكد من وجود الكنترولر الأساسي عند بدء التشغيل
    if (Get.isRegistered<VendorOrderController>()) {
      mainController = Get.find<VendorOrderController>();
    }
    super.onInit();
  }

  @override
  void onReady() {
    getOrdersProduct();
    super.onReady();
  }

  final Crud _crud = Crud();
  Future<void> getOrdersProduct() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      var respo = await _crud.postData(ApiConstants.adminOrder, {
        'action': 'get_order_items',

        'order_id': item.orderId,
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
            ordersProduct.value = decod
                .map((ban) => OrderProductsModel.fromJson(ban))
                .toList();
            // print('orders $orders');
            // print('ordersProduct $ordersProduct');
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
      var respo = await _crud.postData(ApiConstants.adminOrder, {
        'action': 'process_order',
        'order_id': item.orderId,
        'vendor_id': '1',
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

      // تحديث القائمة الرئيسية قبل العودة
      if (Get.isRegistered<VendorOrderController>()) {
        mainController.orders.clear();
        await mainController.getOrders();
      }

      Get.back(); // العودة للصفحة السابقة
      print('finally: Process Finished and Back');
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
