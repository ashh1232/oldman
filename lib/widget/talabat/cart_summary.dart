import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/routes.dart';
import '../../controller/talabat/cart_controllerw.dart';

class CartSummaryWidget extends StatelessWidget {
  final CartController cartController;
  final bool isLoggedIn;

  const CartSummaryWidget({
    super.key,
    required this.cartController,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Obx(() {
          // Accessing products ensures this Obx rebuilds when the cart changes
          final _ = cartController.products.length;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPriceRow('المجموع الفرعي:', cartController.subtotal),
              _buildPriceRow('التوصيل:', cartController.delivery),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي (شامل التوصيل):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${cartController.total.toStringAsFixed(2)} ₪',
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
                  onPressed: () => isLoggedIn
                      ? cartController.checkout()
                      : Get.toNamed(AppRoutes.login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'إتمام الشراء (${cartController.selectedCount.value})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text('${amount.toStringAsFixed(2)} ₪'),
      ],
    );
  }
}
