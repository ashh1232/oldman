import 'core/constants/api_constants.dart';

/// Legacy API links - DEPRECATED
///
/// This class is kept for backward compatibility.
/// Please use ApiConstants instead for all new code.
@Deprecated('Use ApiConstants instead')
class AppaLink {
  // Base URLs
  static String get server => ApiConstants.baseUrl;
  static String get image => ApiConstants.imageBaseUrl;

  // --- Auth & Profile ---
  static String get login => ApiConstants.login;
  static String get signup => ApiConstants.signup;
  static String get profile => ApiConstants.profile;
  static String get favorites => ApiConstants.favorites;

  // --- Products & Categories ---
  static String get product => ApiConstants.products;
  static String get productt => ApiConstants.product2;
  static String get proImages => ApiConstants.productImages;
  static String get cat => ApiConstants.categories;
  static String get banner => ApiConstants.banners;

  // --- Image Paths ---
  static String get productsimages => ApiConstants.productsImages;
  static String get catsimages => ApiConstants.categoriesImages;
  static String get bannersimages => ApiConstants.bannersImages;

  // --- Admin: Products ---
  static String get addProduct => ApiConstants.addProduct;
  static String get uploadImage => ApiConstants.uploadImage;
  static String get update => ApiConstants.update;
  static String get addpro => ApiConstants.addTest;

  // --- Admin: Orders ---
  static String get order => ApiConstants.orders;
  static String get adminOrder =>
      '${ApiConstants.baseUrl}/order/admin_order.php';

  // --- Admin: Category Management ---
  static String get addnewcat => ApiConstants.addCategory;
  static String get category => ApiConstants.editCategory;
  static String get uploadcatImage => ApiConstants.uploadCategoryImage;

  // --- Admin: Banner Management ---
  static String get addnewbanner => ApiConstants.addBanner;
  static String get uploadbanImage => ApiConstants.uploadBannerImage;

  // --- Delivery ---
  static String get delivery => ApiConstants.delivery;
}
