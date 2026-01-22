import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/talabat/cart_controllerw.dart';
import '../../widget/talabat/cart_item.dart';
import '../../widget/talabat/cart_summary.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('سلتك', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartController.products.isEmpty) {
          return _buildEmptyCart();
        }

        return _buildCartContent(context);
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'سلتك فارغة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: cartController.continueShopping,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'استئناف التسوق',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Obx(
                () => Checkbox(
                  value: cartController.selectAll.value,
                  onChanged: (value) {
                    cartController.toggleSelectAll(value ?? false);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  'الكل (${cartController.products.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Cart items List
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: cartController.products.length,
              itemBuilder: (context, index) {
                final product = cartController.products[index];
                return CartItemWidget(
                  product: product,
                  index: index,
                  cartController: cartController,
                );
              },
            ),
          ),
        ),
        // Total summary and checkout
        CartSummaryWidget(cartController: cartController),
      ],
    );
  }
}
