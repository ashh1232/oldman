import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/controller/auth_controller/auth_controller.dart';
import 'package:maneger/controller/talabat_controller/profile_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/order_model.dart';
import 'package:maneger/model/user_model.dart';
import 'package:maneger/model/usr_model.dart';

class DeliveryHomeController extends GetxController {
  // final ProfileController _profileController = Get.find<ProfileController>();
  final AuthController authController = Get.find<AuthController>();

  // Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;
  // Rx<User?> get user => authController.userId;
  final Crud _crud = Crud();
  var isLoading = false.obs;
  var isAdminLoading = false.obs;
  final RxList<Order> orders = <Order>[].obs;
  final RxList<UserModel> admin = <UserModel>[].obs;
  var isAdmin = false.obs;
  RxInt ho = 0.obs;
  @override
  void onInit() {
    // getOrders();
    super.onInit();
  }

  var currentIndex = 0.obs;
  @override
  void onReady() async {
    super.onReady();
    getOrders(); // انقل استدعاء البيانات إلى هنا
    await getAdmin();
    ever(authController.currentUser, (User? user) {
      if (user != null) {
        getAdmin();
      }
    });
    if (authController.userId != null) {
      await getAdmin();
    } else {}
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
            isAdmin.value = true;
            final List decod = res['data'];
            // print(res);
            // print(decod);
            admin.value = decod.map((ban) => UserModel.fromJson(ban)).toList();
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
    final userId = authController.userId;

    print("getAdmin");
    // if (isAdminLoading.value) return;
    // statusRequest.value = StatusRequest.loading;

    try {
      print("1");
      print(userId);
      print(userId);

      isAdminLoading.value = true;
      var respo = await _crud.postData(ApiConstants.adminOrder, {
        'action': 'is_admin',
        'usr_id': userId,
      });
      print("2");

      print('res12www3$respo');

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
          if (res['status'] == 'failure') {
            isAdmin.value = false;
            print('res123$res');
          }
          if (res['status'] == 'success') {
            print('res');

            isAdmin.value = true;
            final List decod = res['data'];
            print('res');
            // print(res);
            // print(decod);
            admin.value = decod.map((ban) => UserModel.fromJson(ban)).toList();
          } else {}
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
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
