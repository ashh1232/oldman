import 'package:get/get.dart';
import 'package:maneger/class/api_service.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/controller/vendor_controller/image_upload_controller.dart';
import 'package:maneger/controller/vendor_controller/vendor_pro_controller.dart';
import 'package:maneger/controller/auth_controller/auth_controller.dart';
import 'package:maneger/controller/delivery_controller/deli_map_controller.dart';
import 'package:maneger/controller/delivery_controller/delivery_home_controller.dart';
import 'package:maneger/controller/home_screen_controller.dart';
import 'package:maneger/controller/product_controller.dart';
import 'package:maneger/controller/shein_controller.dart';
import 'package:maneger/controller/talabat_controller/cart_controllerw.dart';
import 'package:maneger/controller/talabat_controller/checkout_controller.dart';
import 'package:maneger/controller/talabat_controller/profile/profile_controller.dart';
import 'package:maneger/controller/talabat_controller/tal_map_controller.dart';
import 'package:maneger/controller/talabat_controller/talabat_controller.dart';
import 'package:maneger/controller/vendor_controller/ven_home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services (Permanent)
    Get.put(Crud(), permanent: true);
    Get.put(ApiService(), permanent: true);

    // Auth Controller
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

    // User / Talabat Controllers (Lazy)
    Get.lazyPut<HomeScreenController>(
      () => HomeScreenController(),
      fenix: true,
    );
    Get.lazyPut<TalabatController>(() => TalabatController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
    Get.lazyPut<TalMapController>(() => TalMapController(), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    ////admin
    Get.lazyPut<DeliveryHomeController>(
      () => DeliveryHomeController(),
      fenix: true,
    );
    Get.lazyPut<DeliMapController>(() => DeliMapController(), fenix: true);

    ///Vendor
    Get.lazyPut<VenHomeController>(() => VenHomeController(), fenix: true);
    Get.lazyPut<ImageUploadController>(
      () => ImageUploadController(),
      fenix: true,
    );
    Get.lazyPut<VendorProController>(() => VendorProController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
