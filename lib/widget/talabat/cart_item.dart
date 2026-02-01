import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/core/constants/api_constants.dart';
import '../../controller/talabat_controller/cart_controllerw.dart';
import '../../linkapi.dart';
import '../../model/product_model.dart';

class CartItemWidget extends StatelessWidget {
  final Product product;
  final int index;
  final CartController cartController;

  const CartItemWidget({
    super.key,
    required this.product,
    required this.index,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
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
              Obx(
                () => Checkbox(
                  value: cartController.products[index].isSelected,
                  onChanged: (value) {
                    cartController.updateSelectedCount(index, value ?? false);
                  },
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  key: ValueKey(product.image),
                  imageUrl: product.image.startsWith('http')
                      ? product.image
                      : "${ApiConstants.productsImages}/${product.image}",
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
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
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
                          product.price,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product.originalPrice,
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  cartController.removeProduct(index);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 44, top: 8),
            child: Row(
              children: [
                const Text(
                  'الكمية: ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: product.quantity > 1
                            ? () => cartController.updateQuantity(
                                index,
                                product.quantity - 1,
                              )
                            : null,
                        child: const Icon(Icons.remove, size: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${product.quantity}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () => cartController.updateQuantity(
                          index,
                          product.quantity + 1,
                        ),
                        child: const Icon(Icons.add, size: 18),
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
  }
}
