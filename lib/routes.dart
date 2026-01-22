import 'package:get/get.dart';
import 'package:maneger/binding/home_binding.dart';
import 'package:maneger/screen/admin/addproduct_screen.dart';
import 'package:maneger/screen/admin/admin_order_details.dart';
import 'package:maneger/screen/admin/edit_home_screen.dart';
import 'package:maneger/screen/admin/edit_product_detail_view.dart';
import 'package:maneger/screen/delivery/deli_map.dart';
import 'package:maneger/screen/delivery/order_details.dart';
import 'package:maneger/screen/home_screen.dart';
import 'package:maneger/screen/talabat/favorites_screen.dart';
import 'package:maneger/screen/talabat/map_tal.dart';
import 'package:maneger/screen/talabat/talabat_home_screen.dart';
import 'package:maneger/screen/talabat/checkout_screen.dart';
import 'package:maneger/screen/delivery/deli_home.dart';
import 'package:maneger/screen/edit/add_new_cat.dart';
import 'package:maneger/screen/edit/edit_cat_details.dart';
import 'package:maneger/screen/edit/edit_cat_screen.dart';
import 'package:maneger/screen/editbanner/add_banner.dart';
import 'package:maneger/screen/editbanner/edit_ban_details.dart';
import 'package:maneger/screen/editbanner/edit_ban_screen.dart';
import 'package:maneger/screen/talabat/order_confirmation_screen.dart';
import 'package:maneger/screen/talabat/product_detail_view.dart';
import 'package:maneger/screen/talabat/profile_screen.dart';
import 'package:maneger/screen/talabat/cart_page.dart';
import 'package:maneger/screen/auth/login_screen.dart';
import 'package:maneger/screen/message_view.dart';
import 'package:maneger/test/flut_map.dart';
import 'package:maneger/screen/auth/signup_screen.dart';
import 'package:maneger/screen/talabat/category_page.dart';

class AppRoutes {
  // --- Auth Routes ---
  static const login = '/login';
  static const signup = '/signup';

  // --- User / Talabat Routes ---
  static const home = '/';
  static const talabatScreen = '/talabatScreen';
  static const profile = '/profile';
  static const category = '/shein';
  static const productDetail = '/detail';
  static const cartPage = '/cartPage';
  static const checkout = '/checkout';
  static const favorite = '/favorite';
  static const orderConfirmation = '/order-confirmation';
  static const mapScreen = '/mapScreen';

  // --- Admin Routes ---
  static const addscreen = '/addscreen';
  static const editProductScreen = '/editProductScreen';
  static const imageUploadScreen = '/imageUploadScreen';
  static const adminOrderDetails = '/adminOrderDetails';
  static const editCatScreen = '/editCatScreen';
  static const editCatDetailScreen = '/editCatDetailScreen';
  static const addnewcat = '/addnewcat';
  static const editBanScreen = '/editBanScreen';
  static const editBanDetailScreen = '/editBanDetailScreen';
  static const addbanner = '/addbanner';

  // --- Delivery Routes ---
  static const deliHome = '/delihome';
  static const orderDetails = '/orderDetails';
  static const deliMap = '/deliMap';
  static const flutMap = '/flutMap';

  // --- Other ---
  static const mail = '/mail';

  static final routes = [
    // Auth
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => SignupScreen()),

    // App Core / User
    GetPage(name: home, page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(
      name: talabatScreen,
      page: () => TalabatHomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: category, page: () => CategoryPage()),
    GetPage(name: productDetail, page: () => ProductDetailView()),
    GetPage(name: cartPage, page: () => CartPage()),
    GetPage(name: checkout, page: () => CheckoutScreen()),
    GetPage(name: orderConfirmation, page: () => OrderConfirmationScreen()),
    GetPage(name: mapScreen, page: () => MapTal()),
    GetPage(name: favorite, page: () => FavoritesScreen()),

    // Admin
    GetPage(name: addscreen, page: () => AdminProductScreen()),
    GetPage(name: editProductScreen, page: () => EditProductDetailView()),
    GetPage(name: imageUploadScreen, page: () => ImageUploadScreen()),
    GetPage(name: adminOrderDetails, page: () => AdminOrderDetails()),
    GetPage(name: editCatDetailScreen, page: () => EditCatDetailView()),
    GetPage(name: editCatScreen, page: () => EditCategoryScreen()),
    GetPage(name: addnewcat, page: () => AddNewCat()),
    GetPage(name: addbanner, page: () => AddBanner()),
    GetPage(name: editBanDetailScreen, page: () => EditBanDetailView()),
    GetPage(name: editBanScreen, page: () => EditBanScreen()),

    // Delivery
    GetPage(name: deliHome, page: () => DeliHome()),
    GetPage(name: orderDetails, page: () => OrderDetails()),
    GetPage(name: flutMap, page: () => FlutMap()),
    GetPage(name: deliMap, page: () => DeliMap()),

    // Other
    GetPage(name: mail, page: () => MessageView()),
  ];
}
