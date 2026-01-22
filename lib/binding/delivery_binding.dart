import 'package:get/get.dart';
import '../controller/delivery_controller/deli_map_controller.dart';
import '../controller/delivery_controller/delivery_home_controller.dart';

class DeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryHomeController>(
      () => DeliveryHomeController(),
      fenix: true,
    );
    Get.lazyPut<DeliMapController>(() => DeliMapController(), fenix: true);
  }
}
