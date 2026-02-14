import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maneger/class/api_service.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/image_crud.dart';
import 'package:maneger/class/prepare_data.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/cat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:talabat_admin/class/image_crud.dart';
// import 'package:talabat_admin/class/statusrequest.dart';
// import 'package:talabat_admin/linkapi.dart';
// enum ApiStatus { loading, success, error }

// class Plan {
//   final int id;
//   final String label;
//   const Plan(this.id, this.label);
//   bool get isPaid => id > 0;
// }

class NewProductController extends GetxController {
  RxString currentVendor = ''.obs;

  final ImageCrud _imageCrud = ImageCrud();
  var statusRequest = StatusRequest.offline.obs;

  var selectedImage = Rxn<File>();
  var isLoading = false.obs;
  ////////////
  RxList<Category> catList = <Category>[].obs;
  RxBool isCatLoading = false.obs;
  RxInt currentCat = 0.obs;
  final ApiService _apiService = ApiService();

  /////////////////////////////////////
  // var status = ApiStatus.loading.obs;
  // // var selectedPlan = Plan.id.values.obs;
  // void changePlan(Plan newPlan) {
  //   // selectedPlan.value = newPlan;
  // }

  // void fetchData() async {
  //   status.value = ApiStatus.loading;
  //   try {
  //     await Future.delayed(Duration(seconds: 2)); // محاكاة طلب API

  //     // print(Plan.values);
  //     status.value = ApiStatus.success;
  //   } catch (e) {
  //     status.value = ApiStatus.error;
  //   }
  // }

  ///////////////////////////////////////
  // أضف هذه الدالة داخل كلاس Crud لتحويل الأرقام تلقائياً قبل الإرسال

  // حقول إدخال البيانات
  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void onInit() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    checkVendor().then((e) => getCatData());

    super.onInit();
  }

  void changeCat(int newCat) {
    currentCat.value = newCat;
    Get.back();
  }

  Future<void> getCatData() async {
    // 1. تعيين حالة التحميل
    statusRequest.value = StatusRequest.loading;

    // 2. طلب البيانات (النتيجة ستكون Either: Left للفشل أو Right للنجاح)
    final result = await _apiService.getRequestEither(ApiConstants.categories);

    // 3. استخدام Fold لاستخراج البيانات أو معالجة الخطأ
    result.fold(
      (leftFailure) {
        // في حال الفشل (Left)
        statusRequest.value = leftFailure;
      },
      (rightData) {
        // في حال النجاح (Right)
        try {
          statusRequest.value = StatusRequest.success;

          // استخراج القائمة من حقل 'data'
          List responseData = rightData['data'];

          List<Category> loadedData = responseData
              .map((e) => Category.fromJson(e))
              .toList();

          catList.assignAll(loadedData);

          // التحقق إذا كانت القائمة فارغة
          if (catList.isEmpty) statusRequest.value = StatusRequest.none;
        } catch (e) {
          statusRequest.value = StatusRequest.serverfailure;
        }
      },
    );
  }

  // Future<void> getCat() async {
  //   try {
  //     isCatLoading.value = true;
  //     final perfs = await _crud.getData(ApiConstants.categories);

  //     perfs.fold((ifLeft) {}, (data) {
  //       if (data['status'] == 'success') {
  //         List comedata = data['data'];
  //         catList.value = comedata.map((da) => Category.fromJson(da)).toList();
  //         print(' list :  $catList');
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isCatLoading.value = false;
  //   }
  // }

  Future<void> checkVendor() async {
    print('aaaaaaaaaaaaaaaaaaaa');

    final prefs = await SharedPreferences.getInstance();
    print(prefs);
    final userStr = prefs.getString('current_vendor');
    print(userStr);

    if (userStr != null && userStr.isNotEmpty) {
      isLoading.value = true;

      try {
        currentVendor.value = userStr;
        isLoading.value = false;
      } catch (e) {
        Get.snackbar('Error', 'Failed to save user data');
      }
    } else {
      isLoading.value = false;
    }
  }

  // فنكشن اختيار الصورة
  Future<void> pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // ضغط الصورة لـ 70% لتقليل الحجم مع الحفاظ على الجودة
      maxWidth: 1000, // تحديد أقصى عرض للصورة
    );
    if (image != null) selectedImage.value = File(image.path);
  }

  // فنكشن إضافة المنتج والسيرفر
  // تأكد أن النوع هو Future<bool> وليس void
  Future<bool> addNewProduct() async {
    print('object');
    print(currentVendor.value.toString());
    try {
      if (selectedImage.value == null ||
          nameController.text.isEmpty ||
          priceController.text.isEmpty) {
        Get.snackbar("تنبيه", "يرجى ملء جميع الحقول واختيار صورة");
        return false; // إرجاع false في حال عدم اكتمال البيانات
      }

      isLoading.value = true;
      var cleanedData = prepareData({
        "name": nameController.text,
        "price": priceController.text,
        "vendor": currentVendor.value.toString(),
      });

      var response = await _imageCrud.postRequestWithFile(
        ApiConstants.addProduct,
        cleanedData,
        selectedImage.value!,
      );

      isLoading.value = false;
      print(response);
      // يجب استخدام return أمام fold ليعيد النتيجة النهائية
      // print(response['message']);
      return response.fold(
        (l) {
          Get.snackbar("خطأ", "فشل في الاتصال");
          return false;
        },
        (r) {
          if (r['status'] == "success") {
            return true; // نجاح العملية
          } else {
            Get.snackbar("تنبيه", "فشل إضافة المنتج");
            return false;
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("خطأ", "حدث خطأ غير متوقع");
      return false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
