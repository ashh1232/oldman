import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/core/constants/api_constants.dart';

import '../../../model/cat_model.dart';

class EditCatController extends GetxController {
  Crud crud = Crud();

  // تحويل الحالة لتكون قابلة للمراقبة (Rx)
  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;

  // قائمة المنتجات (Rx)
  RxList<Category> data = <Category>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  // gOtdata() async {
  //   var resporight = await crud.postData(ApiConstants.categories, {
  //     'action': 'get_cat',
  //     'cat_id': '5',
  //   });
  //   return respo.fold((l) => l, (r) => r);
  // }

  Future<void> getData() async {
    // print('aaaaaaaaaaaaaaaaaaaaaaaaaaa cat');
    statusRequest.value = StatusRequest.loading;
    var respo = await crud.postData(ApiConstants.categories, {
      'action': 'get_cat',
      'cat_id': '5',
    });
    statusRequest.value = handlingData(respo);

    // print(respo);
    respo.fold((_) => (), (resporight) {
      // print('ssss');
      // print(statusRequest.value);
      // if (statusRequest.value == StatusRequest.success) {
      // print('s');
      if (resporight['status'] == "success") {
        // print('object');
        List<dynamic> decod = resporight['data'];
        data.assignAll(decod.map((e) => Category.fromJson(e)).toList());
      } else {
        statusRequest.value = StatusRequest.failure;
        // }
      }
      // مع Obx، لا نحتاج لاستدعاء update()
    });
  }
}
