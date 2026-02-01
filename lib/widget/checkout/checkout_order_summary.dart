import 'package:flutter/material.dart';
import '../../controller/talabat_controller/checkout_controller.dart';

class CheckoutOrderSummary extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutOrderSummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
          const Text(
            'ملخص الطلب',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'المجموع',
            '${controller.subtotal.toStringAsFixed(2)} ₪',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'التوصيل',
            '${controller.shipping.toStringAsFixed(2)} ₪',
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            'المجموع (شامل التوصيل)',
            '${controller.total.toStringAsFixed(2)} ₪',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.green[700] : Colors.black,
          ),
        ),
      ],
    );
  }
}
