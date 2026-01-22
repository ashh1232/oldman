import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes.dart';
import '../../service/theme_service.dart';

class TalabatDrawer extends StatelessWidget {
  const TalabatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.amber),
            child: Text(
              'Navigation',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildListTile(
            icon: Icons.shopping_bag,
            title: 'تعديل banner',
            onTap: () => _navigate(AppRoutes.editBanScreen),
          ),
          _buildListTile(
            icon: Icons.home,
            title: 'تعديل المنتجات',
            onTap: () => _navigate(AppRoutes.addscreen),
          ),
          _buildListTile(
            icon: Icons.shopping_bag,
            title: 'تعديل الكاتيجوري',
            onTap: () => _navigate(AppRoutes.editCatScreen),
          ),
          _buildListTile(
            icon: Icons.delivery_dining,
            title: 'delivery',
            onTap: () => _navigate(AppRoutes.deliHome),
          ),
          ListTile(
            leading: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            title: Text(Get.isDarkMode ? "الوضع النهاري" : "الوضع الليلي"),
            onTap: () {
              ThemeService().switchTheme();
            },
          ),
          _buildListTile(
            icon: Icons.person,
            title: 'البروفايل',
            onTap: () => _navigate(AppRoutes.profile),
          ),
          _buildListTile(
            icon: Icons.info,
            title: 'للتواصل',
            onTap: () => _navigate(AppRoutes.mail),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  void _navigate(String route) {
    Get.back(); // Close drawer
    Get.toNamed(route);
  }
}
