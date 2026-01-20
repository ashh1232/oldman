import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/admin/admin_pro_order_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/order_model.dart';
import 'package:maneger/routes.dart';

class AdminOrderDetails extends StatelessWidget {
  const AdminOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // التأكد من أن arguments ليست null
    final AdminProOrderController controller = Get.put(
      AdminProOrderController(),
    );
    if (Get.arguments == null) {
      return const Scaffold(body: Center(child: Text("لا توجد بيانات")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل الطلب")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return GridView.builder(
                itemCount: controller.ordersProduct.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) => Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 100,
                          maxHeight: 150,
                        ),
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            key: ValueKey(
                              controller.ordersProduct[index].productImage!,
                            ), // أضف هذا السطر

                            imageUrl:
                                AppLink.productsimages +
                                controller.ordersProduct[index].productImage!,
                            width: double.infinity,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.surface,
                        width: double.infinity,
                        padding: const EdgeInsets.all(7),
                        child: Column(
                          children: [
                            Text(
                              controller.ordersProduct[index].productPrice!
                                  .toString(),
                            ),
                            Text(
                              controller.ordersProduct[index].itemQuantity!
                                  .toString(),
                            ),
                            Text(
                              controller.ordersProduct[index].itemTotal!
                                  .toString(),
                            ),
                            Text(controller.ordersProduct[index].productName!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            // const SizedBox(height: 20),
            // // زر التتبع الداخلي
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     onPressed: () => {},
            //     // Get.toNamed(AppRoutes.deliMap, arguments: item),
            //     icon: const Icon(Icons.location_on),
            //     label: const Text("تتبع عبر الخريطة الداخلية"),
            //   ),
            // ),
            // const SizedBox(height: 12),

            // زر خرائط جوجل
          ),
        ),
      ),
      bottomNavigationBar: _buildPriceSummary(
        context,
        controller.item.orderSubtotal.toString(),
        controller.item.createdAt.toString(),
        controller.item.orderTotal.toString(),
      ),
    );
  }
}

Widget _buildPriceSummary(
  BuildContext context,
  String subtotal,
  String delivery,
  String total,
) {
  void sendOrder() {}
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع الفرعي:',
                style: TextStyle(color: Colors.grey),
              ),
              Text('$subtotal ₪'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('التوصيل:', style: TextStyle(color: Colors.grey)),
              Text('$delivery ₪'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي (شامل التوصيل):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              Text(
                '$total ₪',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => sendOrder(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ارسل ديليفري',
                style: const TextStyle(
                  // color: Theme.,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
