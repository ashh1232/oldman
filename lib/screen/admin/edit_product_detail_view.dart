import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/admin/image_upload_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/widget/bot_nav_widget.dart';

class EditProductDetailView extends GetView<ImageUploadController> {
  //  final ProductController controller = Get.put(ProductController());

  const EditProductDetailView({super.key});
  // final pro = Get.arguments as Product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('تحميل المنتج ...'),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 50,
              backgroundColor: Colors.white,
              elevation: 0.5,
              title: Text(controller.product.value?.title ?? ''),

              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
            // Product Images Section
            SliverToBoxAdapter(child: _buildImageSection(context)),
            SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(child: _buildDeliveryForm(controller, context)),
            SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Product Details Section
            SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تعديل الصورة :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => controller.pickNewImage(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: const Text("اختر الصورة"),
                          ),
                          SizedBox(width: 8),
                          controller.selectedImage.value != null
                              ? Image.file(
                                  controller.selectedImage.value!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 100,
                                ), // Placeholder
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 8)),

            SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(children: [_buildOrderNotes(controller)]),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BotNavWidget(
        pro: controller.product.value!,
        controller: controller,
        isIcon: false,
        onPressed: () =>
            controller.updateProductImage(controller.product.value!.id),
        updateProductImage: "تحديث المنتج",
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  onPageChanged: (index) => controller.selectImage(index),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      key: ValueKey(
                        '${controller.product.value?.image}_${DateTime.now().millisecondsSinceEpoch}',
                      ),

                      imageUrl:
                          '${AppLink.productsimages}${controller.product.value?.image}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildImageSection() {
  //   return Column(
  //     children: [
  //       Container(
  //         color: Color(0xFFF5F5F5),
  //         child: Column(
  //           children: [
  //             SizedBox(
  //               height: 200,
  //               child: Stack(
  //                 children: [
  //                   PageView.builder(
  //                     onPageChanged: (index) => controller.selectImage(index),
  //                     itemCount: 1,
  //                     itemBuilder: (context, index) {
  //                       return CachedNetworkImage(
  //                         key: ValueKey(
  //                           '${controller.product.value?.image}_${DateTime.now().millisecondsSinceEpoch}',
  //                         ),

  //                         imageUrl:
  //                             '${AppLink.productsimages}${controller.product.value?.image}',
  //                         fit: BoxFit.cover,
  //                         placeholder: (context, url) =>
  //                             Center(child: CircularProgressIndicator()),
  //                         errorWidget: (context, url, error) =>
  //                             Icon(Icons.broken_image),
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildPriceSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(
          () => Text(
            '\$${controller.product.value?.price}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
        SizedBox(width: 12),
        Obx(
          () => Text(
            '\$${controller.product.value?.originalPrice}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Obx(
      () => Text(
        controller.product.value?.title ?? '',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDeliveryForm(
    ImageUploadController controller,
    BuildContext context,
  ) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 9),
      // padding: const EdgeInsets.all(5),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(
      //       // ignore: deprecated_member_use
      //       color: Colors.black.withOpacity(0.05),
      //       blurRadius: 10,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      // margin: const EdgeInsets.symmetric(horizontal: 9),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تعديل الاسم و السعر :',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // _buildTextField(
          //   controller: controller.titleController,
          //   label: 'اسم المنتج الجديد',
          //   icon: Icons.person_outline,
          // ),
          // const SizedBox(height: 12),
          // _buildTextField(
          //   controller: controller.priceController,
          //   label: 'السعر',
          //   icon: Icons.phone_outlined,
          //   keyboardType: TextInputType.phone,
          // ),
          // const SizedBox(height: 12),
          // _buildTextField(
          //   controller: controller.descController,
          //   label: 'السعر القديم',
          //   icon: Icons.location_on_outlined,
          //   maxLines: 2,
          Row(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          controller.product.value?.title ?? '',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: _buildTextField(
                          controller: controller.titleController,
                          label: 'اسم المنتج الجديد',
                          icon: Icons.production_quantity_limits,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          controller.product.value?.price ?? '',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: _buildTextField(
                          controller: controller.priceController,
                          label: 'السعر الجديد',
                          icon: Icons.price_check_sharp,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
          // const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildOrderNotes(ImageUploadController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل المنتج (اختياري)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            // controller: controller.notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'اكتب وصفاً مفصلاً للمنتج...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ImageUploadController controller) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () =>
                controller.updateProductImage(controller.product.value!.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: Text(
              'تعديل الصورة',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDescriptionSection(ImageUploadController controllerr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'تفاصيل المنتج',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Obx(
              () => Text(
                controller.product.value?.description ?? 'a',
                style: TextStyle(color: Colors.grey.shade700, height: 1.6),
              ),
            ),
          ],
        ),

        SizedBox(height: 16),
        _buildOrderNotes(controllerr),
        Text(
          'معلومات التوصيل',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'شحن مجاني على الطلبات فوق \$50. التوصيل القياسي يستغرق 7-15 يوم عمل.',
          style: TextStyle(color: Colors.grey.shade700, height: 1.6),
        ),
        SizedBox(height: 16),
        Text(
          'سياسة الارجاع',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'ضمان استرداد المال لمدة 30 يوما. بدون استفسارات.',
          style: TextStyle(color: Colors.grey.shade700, height: 1.6),
        ),
      ],
    );
  }
}
