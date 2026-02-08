import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/vendor_controller/vendor_pro_order_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/widget/talabat/cart_item.dart';

class VendorOrderDetails extends StatelessWidget {
  const VendorOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // التأكد من أن arguments ليست null
    final VendorProOrderController controller = Get.put(
      VendorProOrderController(),
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

          return ListView.builder(
            itemCount: controller.ordersProduct.length,
            itemBuilder: (context, index) {
              final product = controller.ordersProduct[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            key: ValueKey(product.productImage),
                            imageUrl:
                                '${product.productImage}'.startsWith('http')
                                ? '${product.productImage}'
                                : "${ApiConstants.productsImages}/${product.productImage}",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            memCacheWidth: 200,
                            memCacheHeight: 200,
                            placeholder: (context, url) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    product.productPrice.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 44, top: 8),
                      child: Row(
                        children: [
                          const Text(
                            'الكمية: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '${product.itemQuantity}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
          //  GridView.builder(
          //   itemCount: controller.ordersProduct.length,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     mainAxisExtent: 250,
          //     childAspectRatio: 0.8,
          //   ),
          //   itemBuilder: (context, index) => Card(
          //     elevation: 4,
          //     child: Column(
          //       children: [
          //         ConstrainedBox(
          //           constraints: BoxConstraints(minHeight: 100, maxHeight: 150),
          //           child: ClipRRect(
          //             child: CachedNetworkImage(
          //               key: ValueKey(
          //                 controller.ordersProduct[index].productImage!,
          //               ), // أضف هذا السطر

          //               imageUrl:
          //                   ApiConstants.productsImages +
          //                   controller.ordersProduct[index].productImage!,
          //               width: double.infinity,
          //               height: 130,
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //         ),
          //         Container(
          //           color: Theme.of(context).colorScheme.surface,
          //           width: double.infinity,
          //           padding: const EdgeInsets.all(7),
          //           child: Column(
          //             children: [
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Text('اسم المنتج:'),
          //                   Text(controller.ordersProduct[index].productName!),
          //                 ],
          //               ),
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,

          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Text('الكمية:'),
          //                   Text(
          //                     '${controller.ordersProduct[index].itemQuantity!.toString()}x',
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,

          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Text('السعر: '),
          //                   Text(
          //                     '${controller.ordersProduct[index].itemTotal!.toString()} ₪',
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
          //
        }),
      ),
      bottomNavigationBar: Obx(() => _buildPriceSummary(context, controller)),
    );
  }
}

Widget _buildPriceSummary(
  BuildContext context,
  VendorProOrderController controller,
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
