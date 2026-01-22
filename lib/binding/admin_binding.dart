import 'package:get/get.dart';
import '../controller/admin/image_upload_controller.dart';
import '../controller/admin/test_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageUploadController>(
      () => ImageUploadController(),
      fenix: true,
    );
    Get.lazyPut<TestController>(() => TestController(), fenix: true);
  }
}
