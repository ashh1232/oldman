import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/admin/admin_pro_order_controller.dart';
import 'package:maneger/linkapi.dart';

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
        child: Obx(() {
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
                    constraints: BoxConstraints(minHeight: 100, maxHeight: 150),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('اسم المنتج:'),
                            Text(controller.ordersProduct[index].productName!),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('الكمية:'),
                            Text(
                              '${controller.ordersProduct[index].itemQuantity!.toString()}x',
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('السعر: '),
                            Text(
                              '${controller.ordersProduct[index].itemTotal!.toString()} ₪',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Obx(() => _buildPriceSummary(context, controller)),
    );
  }
}

Widget _buildPriceSummary(
  BuildContext context,
  AdminProOrderController controller,
) {
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
              Text('${controller.item.orderSubtotal} ₪'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('التوصيل:', style: TextStyle(color: Colors.grey)),
              Text('${controller.item.createdAt} ₪'),
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
                '${controller.item.orderTotal} ₪',
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
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.updateOrderStatus(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
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
