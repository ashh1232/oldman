import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/vendor_controller/new_product_controller.dart';
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
              Obx(
                () => Column(
                  // children: Plan.values.map((plan) {
                  //   return RadioListTile<Plan>(
                  //     enabled: plan.isPaid,

                  //     title: Text(plan.label.toUpperCase()), // تحويل Enum لنص
                  //     value: plan,
                  //     // groupValue: controller.selectedPlan.value,
                  //     onChanged: (val) => controller.changePlan(val!),
                  //   );
                  // }).toList(),
                ),
              ),
              FloatingActionButton(
                onPressed: () => controller.fetchData(),
                child: Icon(Icons.refresh),
              ),
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
                          bool success = await controller.addProduct();
                          if (success) {
                            // العودة للصفحة السابقة وتلقائياً TestScreen ستحدث بياناتها
                            Get.back();
                          }
                        },
                        child: const Text("حفظ المنتج"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
