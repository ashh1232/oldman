import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/user_model.dart';

class AdminManegerController extends GetxController {
  final Crud _crud = Crud();
  RxBool isAdminLoading = false.obs;
  RxList<User> admin = <User>[].obs;
  @override
  void onInit() {
    getVendorRequest();
    super.onInit();
  }

  Future<void> getVendorRequest() async {
    try {
      var respo = await _crud.postData(ApiConstants.newVendor, {
        'action': 'get_all_admin_orders',
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
            // isAdmin.value = false;
          }
          if (res['status'] == 'success') {
            // isAdmin.value = true;
            final List decod = res['data'];

            admin.value = decod.map((ban) => User.fromJson(ban)).toList();
          } else {}
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
    } finally {
      // isAdminLoading.value = false;
    }
  }

  Future<void> acceptAdmin(String userId) async {
    print(userId);
    try {
      isAdminLoading.value = true;
      var respo = await _crud.postData(ApiConstants.newVendor, {
        'action': 'accept_vendor_request',
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
            isAdminLoading.value = false;
          }
          if (res['status'] == 'success') {
            admin.removeWhere((user) => user.userId == userId);
            Get.rawSnackbar(
              message: 'تم القبول',
              backgroundColor: Colors.lightGreen,
              duration: Duration(milliseconds: 900),
            );
          } else {}
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e', backgroundColor: Colors.red);
    } finally {
      getVendorRequest();
      isAdminLoading.value = false;
    }
  }
}
