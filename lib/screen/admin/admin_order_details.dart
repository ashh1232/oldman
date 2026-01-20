import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/model/order_model.dart';
import 'package:maneger/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminOrderDetails extends StatelessWidget {
  const AdminOrderDetails({super.key});

  Future<void> openMap(String? latStr, String? lngStr) async {
    // تحويل آمن للنصوص إلى أرقام
    final double? lat = double.tryParse(latStr ?? '');
    final double? lng = double.tryParse(lngStr ?? '');

    if (lat == null || lng == null) {
      Get.snackbar("تنبيه", "إحداثيات الموقع غير صالحة");
      return;
    }

    final Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    try {
      // في Flutter 2026 يفضل استخدام launchUrl مباشرة مع معالجة الخطأ
      bool launched = await launchUrl(
        googleUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar("خطأ", "لا يمكن فتح تطبيق الخرائط");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير متوقع: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // التأكد من أن arguments ليست null
    if (Get.arguments == null) {
      return const Scaffold(body: Center(child: Text("لا توجد بيانات")));
    }

    final Order item = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل الطلب")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text("رقم الطلب: ${item.orderId}"),
                subtitle: Text("حالة الطلب: ${item.orderStatus}"),
              ),
            ),
            const SizedBox(height: 20),
            // زر التتبع الداخلي
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Get.toNamed(AppRoutes.deliMap, arguments: item),
                icon: const Icon(Icons.location_on),
                label: const Text("تتبع عبر الخريطة الداخلية"),
              ),
            ),
            const SizedBox(height: 12),
            // زر خرائط جوجل
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => openMap(item.deliveryLat, item.deliveryLong),
                icon: const Icon(Icons.map_outlined),
                label: const Text("فتح في خرائط Google"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
