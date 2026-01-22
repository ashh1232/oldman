import 'admin_link.dart';

class AppLink {
  // Base URLs
  static const String server = AdminLink.server;
  static const String image = AdminLink.image;

  // --- Auth & Profile ---
  static const String login = '$server/login.php';
  static const String signup = '$server/signup.php';
  static const String profile = '$server/profile.php';
  static const String favorites = '$server/favorites.php';

  // --- Products & Categories ---
  static const String product = '$server/product.php';
  static const String productt = '$server/product2.php';
  static const String proImages = '$server/products/pro_images.php';
  static const String cat = '$server/catt.php';
  static const String banner = '$server/banner.php';

  // --- Image Paths ---
  static const String productsimages = '$image/productsImages/';
  static const String catsimages = '$image/catsImages/';
  static const String bannersimages = '$image/bannersImages/';

  // --- Admin: Products ---
  static const String addProduct = '$server/admin/add_product.php';
  static const String uploadImage = '$server/admin/upload_image.php';
  static const String update = '$server/update_test.php';
  static const String addpro = '$server/add_test.php';

  // --- Admin: Orders ---
  static const String order = '$server/order/order.php';
  static const String adminOrder = '$server/order/admin_order.php';

  // --- Admin: Category Management ---
  static const String addnewcat = '$server/editcat/add_cat.php';
  static const String category = '$server/editcat/edit_cat.php';
  static const String uploadcatImage = '$server/editcat/upload_cat_image.php';

  // --- Admin: Banner Management ---
  static const String addnewbanner = '$server/banner/add_ban.php';
  static const String uploadbanImage = '$server/banner/upload_ban_image.php';

  // --- Delivery ---
  static const String delivery = '$server/delivery/delivery_order.php';
}
