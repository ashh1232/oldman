import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/talabat/checkout_controller.dart';

class CheckoutDeliveryForm extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutDeliveryForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
            children: [
              const Text(
                'معلومات التوصيل',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Obx(
                () => IconButton(
                  icon: Icon(
                    controller.isEditing.value ? Icons.close : Icons.edit,
                  ),
                  onPressed: () => controller.toggleEditMode(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isEditing.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تعديل الملف الشخصي',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildEditField(
                    controller: controller.nameController,
                    label: 'الاسم',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _buildEditField(
                    controller: controller.phoneController,
                    label: 'رقم الهاتف',
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildEditField(
                    controller: controller.addressController,
                    label: 'العنوان',
                    icon: Icons.location_on_outlined,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () =>
                          controller.profileController.updateProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'حفظ التغييرات',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المعلومات الشخصية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.person_outline,
                    'الاسم',
                    controller.user.value?.userName ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    'رقم الهاتف',
                    controller.user.value?.userPhone ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    'العنوان',
                    controller.user.value?.userAddress ?? 'N/A',
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  //   Widget _buildTextField({
  //     required TextEditingController controller,
  //     required String label,
  //     required IconData icon,
  //     TextInputType? keyboardType,
  //     int maxLines = 1,
  //   }) {
  //     return TextField(
  //       controller: controller,
  //       keyboardType: keyboardType,
  //       maxLines: maxLines,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         prefixIcon: Icon(icon, color: Colors.black),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8),
  //           borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8),
  //           borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8),
  //           borderSide: const BorderSide(color: Colors.blue, width: 2),
  //         ),
  //         filled: true,
  //         fillColor: Colors.grey[50],
  //       ),
  //     );
  //   }
  // }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700], size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
