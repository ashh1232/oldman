import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:maneger/class/image_handling.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/vendor_controller/vendor_pro_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/routes.dart';
import 'package:maneger/widget/loading_card.dart';
import 'package:maneger/widget/tal_container.dart';

class VendorProductScreen extends StatelessWidget {
  const VendorProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VendorProController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        // title: const Text("المنتجات"),
        actions: [
          InkWell(
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.amber.shade300,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: .5,
                    offset: Offset.fromDirection(.51),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'أضف منتج جديد',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.add),
                ],
              ),
            ),
            onTap: () async {
              await Get.toNamed(AppRoutes.imageUploadScreen);
              controller.getData(); // التحديث عند العودة
            },
          ),
          // IconButton(
          //   onPressed: () async {
          //     await Get.toNamed(AppRoutes.imageUploadScreen);
          //     controller.getData(); // التحديث عند العودة
          //   },
          //   icon: const Icon(Icons.add),
          // ),
          SizedBox(width: 7),
        ],
      ),
      // استخدام Obx لمراقبة التغيرات تلقائياً
      body: Obx(() {
        if (controller.statusRequest.value == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.statusRequest.value == StatusRequest.offline) {
          return const Center(child: Text("لا يوجد اتصال بالانترنت"));
        } else if (controller.statusRequest.value == StatusRequest.failure ||
            controller.data.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("لا يوجد بيانات"),
              ElevatedButton(
                onPressed: () async {
                  controller.data.clear();
                  await controller.getData();
                },
                child: Text("تحديث"),
              ),
            ],
          );
        } else {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async => controller.getData(),
              ),
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Column(
                    children: [
                      TalContainer(
                        title: 'اضف اعلان :',
                        body: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: .5,
                                offset: Offset.fromDirection(.51),
                              ),
                            ],
                          ),
                          width: double.infinity,

                          margin: EdgeInsets.all(25),
                          child: Icon(
                            Icons.add,
                            size: 105,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Column(
                    children: [
                      TalContainer(
                        title: 'اضف موقع متجرك :',
                        body: CheckoutMapPreview(
                          controller: controller,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // CupertinoSliverRefreshControl(
              //   onRefresh: () async => await controller.getData(),
              // ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: controller.data.length,
                  itemBuilder: (context, index) {
                    final product = controller.data[index];
                    return InkWell(
                      onTap: () => Get.toNamed(
                        AppRoutes.editProductScreen,
                        arguments: product,
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                key: ValueKey(
                                  '${product.image}_${DateTime.now().millisecondsSinceEpoch}',
                                ),
                                imageUrl: getImageUrl(
                                  product.image,
                                  ApiConstants.productsImages,
                                ),
                                //  product.image.startsWith('http')
                                //     ? product.image
                                //     : '${ApiConstants.productsImages}/${product.image}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                // تعامل مع الخطأ في حال لم تحمل الصورة
                                placeholder: (context, url) => const Center(
                                  child: LoadingCard(height: 100),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        // Text(product.isAvailable ? 'متوفر' : 'غير متوفر'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    children: [
                                      Container(
                                        width: 50,
                                        child: Text(
                                          product.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        product.price,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Text(
                                      //   product.originalPrice,
                                      //   maxLines: 1,
                                      //   overflow: TextOverflow.ellipsis,
                                      //   style: const TextStyle(
                                      //     fontWeight: FontWeight.bold,
                                      //     decoration:
                                      //         TextDecoration.lineThrough,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget CheckoutMapPreview({
    required VendorProController controller,
    required context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'موقع التوصيل',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => controller.openMap(),
                icon: const Icon(Icons.edit_location_alt, size: 20),
                label: const Text('تغيير'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => controller.openMap(),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Obx(() {
                  if (controller.ismap.value) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(Icons.location_off, size: 55),
                        Text(
                          "لا يوجد موقع محدد",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }
                  if (controller.selectedLat.value == 0.0 &&
                      controller.selectedLong.value == 0.0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_off, size: 55),
                          Text(
                            "لا يوجد موقع محدد",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return IgnorePointer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          controller.selectedLat.value,
                          controller.selectedLong.value,
                        ),
                        initialZoom: 17.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
                          userAgentPackageName: 'com.docana.manager',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                controller.selectedLat.value,
                                controller.selectedLong.value,
                              ),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
