import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maneger/class/api_service.dart';

import 'package:maneger/class/image_crud.dart';
import 'package:maneger/class/prepare_data.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/cat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProductController extends GetxController {
  RxString currentVendor = ''.obs;

  final ImageCrud _imageCrud = ImageCrud();
  var statusRequest = StatusRequest.offline.obs;
  TextEditingController productNotesController = TextEditingController();

  var selectedImage = Rxn<File>();
  var isLoading = false.obs;
  ////////////
  RxList<Category> catList = <Category>[].obs;
  RxBool isCatLoading = false.obs;
  RxInt currentCat = 0.obs;
  final ApiService _apiService = ApiService();

  // حقول إدخال البيانات
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController noteController;
  late String catId;
  @override
  void onInit() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    noteController = TextEditingController();
    checkVendor()
        .then((e) => getCatData())
        .then((onValue) => catId = catList.first.id);

    super.onInit();
  }

  void changeCat(int newCat) {
    currentCat.value = newCat;
    catId = catList[newCat].id;
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

  Future<void> checkVendor() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('current_vendor');

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
        "catId": catId.toString(),
        "note": noteController.text,
      });

      var response = await _imageCrud.postRequestWithFile(
        ApiConstants.addProduct,
        cleanedData,
        selectedImage.value!,
      );

      isLoading.value = false;
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
    noteController.dispose();
    super.onClose();
  }
}
