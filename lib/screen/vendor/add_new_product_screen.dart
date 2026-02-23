import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/handlingdataview.dart';
import 'package:maneger/class/image_handling.dart';
import 'package:maneger/controller/vendor_controller/new_product_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/widget/bot_nav_widget.dart';
import 'package:maneger/widget/build_edit_field.dart';
import 'package:maneger/widget/tal_container.dart';
import 'package:maneger/widget/vendor/build_order_notes.dart';

class AddNewProductScreen extends StatelessWidget {
  const AddNewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewProductController controller = Get.put(NewProductController());

    return Scaffold(
      appBar: AppBar(title: const Text('اضافة منتج جديد')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TalContainer(
              title: 'اضف صورة المنتج',
              body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ElevatedButton(
                  //   onPressed: () => controller.pickImage(),
                  //   child: const Text("اختر الصورة"),
                  // ),
                  // حقل اسم المنتج
                  Obx(
                    () => controller.selectedImage.value != null
                        ? Image.file(
                            controller.selectedImage.value!,
                            height: 200,
                          )
                        : IconButton(
                            icon: Icon(Icons.add_a_photo, size: 200),
                            onPressed: () => controller.pickImage(),
                          ),
                  ),
                ],
              ),
              desc: 'اضف صورة المنتج',
            ),
            TalContainer(
              title: 'معلومات المنتج',
              body: Column(
                children: [
                  BuildEditField(
                    controller: controller.nameController,
                    label: 'اسم المنتج',
                    icon: Icons.text_fields,
                  ),
                  SizedBox(height: 10),
                  BuildEditField(
                    controller: controller.priceController,
                    label: 'سعر المنتج',
                    icon: Icons.attach_money,
                  ),

                  // حقل اسم المنتج
                ],
              ),
              desc: 'الرجاء اضافه اسم و سعر المنتج الجديد',
            ),
            TalContainer(
              title: 'القسم',
              body: Column(
                children: [
                  // حقل اسم المنتج
                  Obx(() {
                    return HandlingDataView(
                      statusRequest: controller.statusRequest.value,
                      widget: controller.catList.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(3),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(03, 5),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200], // لون خلفية للصورة
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8), //
                                    child: CachedNetworkImage(
                                      key: ValueKey(
                                        '${controller.catList[controller.currentCat.value].image}_${DateTime.now().millisecondsSinceEpoch}',
                                      ),
                                      imageUrl: getImageUrl(
                                        controller
                                            .catList[controller
                                                .currentCat
                                                .value]
                                            .image,
                                        ApiConstants.categoriesImages,
                                      ),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  controller
                                      .catList[controller.currentCat.value]
                                      .title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_drop_down),
                                onTap: () => Get.bottomSheet(
                                  Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    child: ListView.builder(
                                      itemCount: controller.catList.length,
                                      itemBuilder: (c, s) {
                                        final cat = controller.catList[s];
                                        return ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 4,
                                              ), // مساحة تنفس
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .grey[200], // لون خلفية للصورة
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    8,
                                                  ), // تدوير حواف الصورة
                                              child: CachedNetworkImage(
                                                key: ValueKey(
                                                  '${cat.image}_${DateTime.now().millisecondsSinceEpoch}',
                                                ),
                                                imageUrl: getImageUrl(
                                                  cat.image,
                                                  ApiConstants.categoriesImages,
                                                ),
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                      child: SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            cat.title, // تأكد أن النوع String في الـ Model
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          trailing:
                                              controller.currentCat.value == s
                                              ? const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                ) // أيقونة أوضح للنجاح
                                              : const SizedBox.shrink(),
                                          onTap: () => controller.changeCat(s),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const Text("لا توجد أقسام متاحة"),
                    );
                  }),
                ],
              ),
              desc: 'اختر نوع المنتج',
            ),

            TalContainer(
              title: 'تفاصيل المنتج (اختياري)',
              body: BuildOrderNotes(controller: controller.noteController),
              desc: 'تفاصيل المنتج (اختياري) اضف تفاصيل للمنتج الجديد',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BotNavWidget(
        isIcon: false,
        updateProductImage: "إضافة المنتج الآن",
        controller: controller,
        onPressed: () async {
          bool success = await controller.addNewProduct();
          if (success) {
            // العودة للصفحة السابقة وتلقائياً TestScreen ستحدث بياناتها
            Get.back();
          }
        },
        // ,pro: null ,
      ),
    );
  }
}
