import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/delivery_controller/delivery_home_controller.dart';
import 'package:maneger/screen/vendor/vendor_product_screen.dart';
import 'package:maneger/screen/vendor/vendor_order_screen.dart';
import 'package:maneger/screen/vendor/vendor_delivery.dart';

class VendorHome extends StatelessWidget {
  VendorHome({super.key});
  final DeliveryHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("قائمة الطلبات")), // إضافة عنوان
      body: Obx(
        () => controller.isAdmin.value
            ? IndexedStack(
                index: controller.currentIndex.value,
                children: [
                  VendorOrderScreen(), // التبويب الرئيسي
                  VendorDelivery(),
                  VendorProductScreen(),
                ],
              )
            : newVendor(),
      ),

      bottomNavigationBar: Obx(
        () => controller.isAdmin.value
            ? BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: (index) {
                  controller.currentIndex.value = index;
                },
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                elevation: 10,
                selectedFontSize: 12, // تصغير الخط قليلاً لتجنب الـ Overflow
                unselectedFontSize: 10,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.delivery_dining_outlined),
                    activeIcon: Icon(Icons.delivery_dining),
                    label: 'التوصيل',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.admin_panel_settings_outlined),
                    activeIcon: Icon(Icons.admin_panel_settings),
                    label: 'الإدارة',
                  ),
                ],
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Center newVendor() => Center(
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'انت تاجر و تريد عرض منتوجاتك هنا \n قدم طلب عضويه مجاني \n ${controller.ho}',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () => controller.newVendor(),
            child: Text('تقديم طلب'),
          ),
        ],
      ),
    ),
  );
}
