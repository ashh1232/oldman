import 'package:get/get.dart';
import 'package:maneger/controller/vendor_controller/ven_home_controller.dart';
import '../controller/vendor_controller/image_upload_controller.dart';
import '../controller/vendor_controller/test_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageUploadController>(
      () => ImageUploadController(),
      fenix: true,
    );
    Get.lazyPut<TestController>(() => TestController(), fenix: true);
    Get.lazyPut<VenHomeController>(() => VenHomeController(), fenix: true);
  }
}
