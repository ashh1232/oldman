import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/controller/auth_controller/auth_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/order_model.dart';
import 'package:maneger/model/user_model.dart';
import 'package:maneger/model/usr_model.dart';

class DeliveryHomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final Crud _crud = Crud();
  var isLoading = false.obs;
  var isAdminLoading = false.obs;
  final RxList<Order> orders = <Order>[].obs;
  final RxBool admin = false.obs;
  var isAdmin = false.obs;
  RxInt ho = 0.obs;
  User? get zuser => authController.currentUser.value;
  @override
  void onInit() async {
    // // zuser = await authController.userId;
    // authController.checkLoginStatus().then((value) => print(zuser));
    // print('zuser');
    // print(zuser);
    // print('zuser');
    super.onInit();
  }

  // String? get zuser => authController.userId;
  var currentIndex = 0.obs;
  @override
  void onReady() {
    super.onReady();
    getOrders(); // انقل استدعاء البيانات إلى هنا

    // authController.checkLoginStatus().then((value) => getAdmin());

    // ever(authController.currentUser, (User? user) {
    //   if (user != null) {
    getAdmin();
    //   }
    // });
    // if (authController.userId != null) {
    //   await getAdmin();
    // } else {}
  }

  Future<void> newVendor() async {
    final userId = authController.userId;
    ho.value++;
    try {
      var respo = await _crud.postData(ApiConstants.newVendor, {
        'action': 'add_new_vendor',
        'user_id': userId,
      });

      respo.fold(
        (status) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.context != null && !Get.isSnackbarOpen) {
              Get.rawSnackbar(
                message: "خطأ في التحميل",
                duration: Duration(milliseconds: 900),
              );
            }
          });
        },
        (res) {
          if (res['status'] == 'failure') {
            isAdmin.value = false;
          }
          if (res['status'] == 'success') {
            // final List decod = res['data'];
            // print(res);
            // print(decod);
            // admin.value = decod.map((ban) => UserModel.fromJson(ban)).toList();
          } else {}
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
    } finally {
      isAdminLoading.value = false;
    }
  }

  Future<void> getAdmin() async {
    isAdminLoading.value = true;

    try {
      // 1. يفضل انتظار حالة تسجيل الدخول قبل المتابعة
      await authController.checkLoginStatus();

      // 2. تأكد من أن المستخدم ليس null قبل إرسال الطلب
      if (zuser == null) {
        isAdminLoading.value = false;
        return;
      }
      print('zuser');
      print(zuser!.userId.toString());
      print('zuser231');
      var respo = await _crud.postData(ApiConstants.adminOrder, {
        'action': 'is_admin',
        'usr_id': zuser!.userId,
      });
      print(respo);
      respo.fold(
        (status) {
          // استخدام Get.snackbar مباشرة أسهل وأكثر توافقاً مع GetX
          Get.snackbar(
            "تنبيه",
            "خطأ في التحميل: $status",
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (res) {
          if (res['status'] == 'success') {
            if (res['vendor_data'] != null) {
              print('Vendor ID: ${res['vendor_data']}');
              // ملاحظة: إذا كان vendor_data مجرد رقم (73)، فلا يمكنك تحويله لـ List<UserModel>
              // ستحتاج لتعديل منطق تخزين البيانات هنا بناءً على حاجتك
            }
            if (res['is_admin'] != null) {
              print(res['is_admin']);
              bool iss = res['is_admin'];
              admin.value = iss;
              isAdmin.value = iss;
            }
            // final List decod = res['data'];
            // print('decod');
            // print(decod);
            // admin.value = decod.map((ban) => UserModel.fromJson(ban)).toList();
            // print(admin.value);
          } else {
            isAdmin.value = false; // تأكد من إعادة التعيين في حال الفشل
          }
        },
      );
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'حدث خطأ غير متوقع: $e');
    } finally {
      isAdminLoading.value = false;
    }
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
