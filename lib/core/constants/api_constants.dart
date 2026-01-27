import '../config/environment_manager.dart';

/// API endpoints and configuration constants
///
/// Centralized location for all API-related constants
/// URLs are now dynamically loaded from the current environment
class ApiConstants {
  ApiConstants._(); // Private constructor to prevent instantiation

  // Get environment manager instance
  static final _env = EnvironmentManager();

  // Base URLs (dynamically loaded from environment)
  static String get baseUrl => _env.serverUrl;
  static String get imageBaseUrl => _env.imageUrl;

  // API Endpoints
  static String get login => '$baseUrl/auth/login.php';
  static String get signup => '$baseUrl/auth/signup.php';
  static String get profile => '$baseUrl/auth/profile.php';

  // Products
  static String get products => '$baseUrl/product.php';
  static String get product2 => '$baseUrl/product2.php';
  static String get productImages => '$baseUrl/products/pro_images.php';

  // Categories
  static String get categories => '$baseUrl/catt.php';
  static String get addCategory => '$baseUrl/editcat/add_cat.php';
  static String get uploadCategoryImage =>
      '$baseUrl/editcat/upload_cat_image.php';
  static String get editCategory => '$baseUrl/editcat/edit_cat.php';

  // Banners
  static String get banners => '$baseUrl/banner.php';
  static String get addBanner => '$baseUrl/banner/add_ban.php';
  static String get uploadBannerImage => '$baseUrl/banner/upload_ban_image.php';

  // Orders
  static String get orders => '$baseUrl/order/order.php';
  static String get delivery => '$baseUrl/delivery/delivery_order.php';

  // Favorites
  static String get favorites => '$baseUrl/favorites.php';

  // Admin
  static String get addProduct => '$baseUrl/admin/add_product.php';
  static String get uploadImage => '$baseUrl/admin/upload_image.php';
  static String get adminOrder => '$baseUrl/order/admin_order.php';

  // Misc
  static String get update => '$baseUrl/update_test.php';
  static String get addTest => '$baseUrl/add_test.php';

  // Image Paths
  static String get productsImages => '$imageBaseUrl/productsImages/';
  static String get categoriesImages => '$imageBaseUrl/catsImages/';
  static String get bannersImages => '$imageBaseUrl/bannersImages/';

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
