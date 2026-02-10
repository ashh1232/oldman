import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorProController extends GetxController {
  final Crud crud = Crud(); // استخدام final أفضل

  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;
  RxList<Product> data = <Product>[].obs;
  RxBool isLoading = false.obs;
  RxString currentVendor = ''.obs;
  @override
  void onInit() {
    checkVendor().then((a) => getData());
    print('currentVendor');

    super.onInit();
  }

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
        print('asdasdasd');
        print(currentVendor);
      } catch (e) {
        Get.snackbar('Error', 'Failed to save user data');
      }
    } else {
      isLoading.value = false;
    }
  }

  // دالة جلب البيانات الخام
  Future<dynamic> _fetchRawData() async {
    print('aaaaaaaaa');
    print(currentVendor);
    print('rrrrr');
    var respo = await crud.postData(ApiConstants.products, {
      'vendor': currentVendor.toString(),
    });
    print(respo);
    print('respo');

    return respo.fold((l) => l, (r) => r);
  }

  Future<void> getData() async {
    print('currentVendor');
    print(currentVendor);
    // إظهار التحميل فقط إذا كانت القائمة فارغة (تحسين تجربة المستخدم)
    if (data.isEmpty) {
      statusRequest.value = StatusRequest.loading;
    }

    var respo = await _fetchRawData();
    statusRequest.value = handlingData(respo);

    if (statusRequest.value == StatusRequest.success) {
      if (respo['status'] == "success") {
        List<dynamic> decod = respo['data'];

        // تحويل البيانات وتحديث القائمة
        List<Product> newList = decod.map((e) => Product.fromJson(e)).toList();
        data.assignAll(newList);
      } else {
        // في حال نجح الطلب لكن السيرفر أعاد "no data"
        if (data.isEmpty) statusRequest.value = StatusRequest.failure;
      }
    }
  }
}
