import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class PersonalInfoForm extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const PersonalInfoForm({
    super.key,
    required this.isEditing,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildEditableField(
          label: 'Full Name',
          controller: nameController,
          icon: Icons.person,
          enabled: isEditing,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildEditableField(
          label: 'Email Address',
          controller: emailController,
          icon: Icons.email,
          enabled: isEditing,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildEditableField(
          label: 'Phone Number',
          controller: phoneController,
          icon: Icons.phone,
          enabled: isEditing,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildEditableField(
          label: 'Delivery Address',
          controller: addressController,
          icon: Icons.location_on,
          enabled: isEditing,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !enabled,
        fillColor: enabled ? Colors.transparent : Colors.grey[100],
      ),
    );
  }
}