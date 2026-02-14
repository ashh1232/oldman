import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/handlingdataview.dart';
import 'package:maneger/class/image_handling.dart';
import 'package:maneger/controller/vendor_controller/new_product_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
// import 'package:talabat_admin/controller/new_product_controller.dart';

class AddNewProductScreen extends StatelessWidget {
  const AddNewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewProductController controller = Get.put(NewProductController());

    return Scaffold(
      appBar: AppBar(title: const Text('اضافة منتج جديد')),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // حقل اسم المنتج
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "اسم المنتج"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.priceController,
                decoration: const InputDecoration(labelText: "سعر المنتج"),
              ),
              const SizedBox(height: 15),
              Obx(() {
                return HandlingDataView(
                  statusRequest: controller.statusRequest.value,
                  widget: controller.catList.isNotEmpty
                      ? Container(
                          color: Theme.of(context).colorScheme.surface,
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
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8), //
                                child: CachedNetworkImage(
                                  imageUrl: getImageUrl(
                                    controller
                                        .catList[controller.currentCat.value]
                                        .image,
                                    ApiConstants.categoriesImages,
                                  ),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
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
                                color: Theme.of(context).colorScheme.surface,
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ), // تدوير حواف الصورة
                                          child: CachedNetworkImage(
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
                                                (context, url, error) =>
                                                    const Icon(
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
                                      trailing: controller.currentCat.value == s
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

              const SizedBox(height: 15),

              // عرض الصورة المختارة
              Obx(
                () => controller.selectedImage.value != null
                    ? Image.file(controller.selectedImage.value!, height: 200)
                    : Icon(Icons.image, size: 200),
              ),

              ElevatedButton(
                onPressed: () => controller.pickImage(),
                child: const Text("اختر الصورة"),
              ),

              const SizedBox(height: 30),

              // زر الحفظ النهائي
              Obx(
                () => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          bool success = await controller.addNewProduct();
                          if (success) {
                            // العودة للصفحة السابقة وتلقائياً TestScreen ستحدث بياناتها
                            Get.back();
                          }
                        },
                        child: const Text("إضافة المنتج الآن"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
