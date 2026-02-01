import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/user_model.dart';
import 'package:maneger/model/usr_model.dart';

class AdminManegerController extends GetxController {
  final Crud _crud = Crud();

  RxList<User> admin = <User>[].obs;
  @override
  void onInit() {
    newVendor();
    super.onInit();
  }

  Future<void> newVendor() async {
    print('user.value!.userId');
    try {
      var respo = await _crud.postData(ApiConstants.newVendor, {
        'action': 'get_all_admin_orders',
      });
      print('object123');
      print(respo);
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
            print(res);
            print(decod);
            admin.value = decod.map((ban) => User.fromJson(ban)).toList();
            print(admin.value);
          } else {}
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
    } finally {
      // isAdminLoading.value = false;
    }
  }
}
