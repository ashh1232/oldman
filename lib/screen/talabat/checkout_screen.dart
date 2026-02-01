import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/talabat_controller/checkout_controller.dart';
import '../../widget/checkout/checkout_order_summary.dart';
import '../../widget/checkout/checkout_delivery_form.dart';
import '../../widget/checkout/checkout_map_preview.dart';
import '../../widget/checkout/checkout_payment_selector.dart';
import '../../widget/checkout/checkout_notes.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckoutController controller = Get.find<CheckoutController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الطلب'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isProcessing.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              CheckoutOrderSummary(controller: controller),
              const SizedBox(height: 8),
              CheckoutDeliveryForm(controller: controller),
              const SizedBox(height: 8),
              CheckoutMapPreview(controller: controller),
              const SizedBox(height: 8),
              // CheckoutPaymentSelector(controller: controller),
              // const SizedBox(height: 8),
              CheckoutNotes(controller: controller),
              const SizedBox(height: 24),
              _buildPlaceOrderButton(controller),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPlaceOrderButton(CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () => controller.placeOrder(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'إرسال الطلب',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
