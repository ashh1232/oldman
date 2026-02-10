import 'package:get/get.dart';
import 'package:maneger/controller/auth_controller/storage_service.dart';
import '../controller/delivery_controller/deli_map_controller.dart';
import '../controller/delivery_controller/delivery_home_controller.dart';

class DeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService(), permanent: true);
    Get.lazyPut<DeliveryHomeController>(
      () => DeliveryHomeController(),
      fenix: true,
    );
    Get.lazyPut<DeliMapController>(() => DeliMapController(), fenix: true);
  }
}
