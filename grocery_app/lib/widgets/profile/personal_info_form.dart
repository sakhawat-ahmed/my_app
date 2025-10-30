import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class PersonalInfoForm extends StatelessWidget {
  final bool isEditing;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final Map<String, dynamic>? user;

  const PersonalInfoForm({
    super.key,
    required this.isEditing,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Name and Last Name in a row
        Row(
          children: [
            Expanded(
              child: _buildEditableField(
                label: 'First Name',
                controller: firstNameController,
                icon: Icons.person_outline,
                enabled: isEditing,
                initialValue: user?['first_name'] ?? '',
              ),
            ),
            SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
            Expanded(
              child: _buildEditableField(
                label: 'Last Name',
                controller: lastNameController,
                icon: Icons.person_outline,
                enabled: isEditing,
                initialValue: user?['last_name'] ?? '',
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        
        _buildEditableField(
          label: 'Email Address',
          controller: emailController,
          icon: Icons.email_outlined,
          enabled: isEditing,
          keyboardType: TextInputType.emailAddress,
          initialValue: user?['email'] ?? '',
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        
        _buildEditableField(
          label: 'Phone Number',
          controller: phoneController,
          icon: Icons.phone_outlined,
          enabled: isEditing,
          keyboardType: TextInputType.phone,
          initialValue: user?['phone'] ?? '',
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        
        _buildEditableField(
          label: 'Delivery Address',
          controller: addressController,
          icon: Icons.location_on_outlined,
          enabled: isEditing,
          maxLines: 2,
          initialValue: user?['address'] ?? '',
        ),
        
        // User Type Display (Read-only)
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildReadOnlyField(
          label: 'Account Type',
          value: _getUserTypeDisplay(),
          icon: Icons.badge_outlined,
        ),
        
        // Username Display (Read-only)
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildReadOnlyField(
          label: 'Username',
          value: user?['username'] ?? 'Not set',
          icon: Icons.alternate_email_outlined,
        ),
        
        // User ID Display (Read-only)
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildReadOnlyField(
          label: 'User ID',
          value: user?['id']?.toString() ?? 'N/A',
          icon: Icons.credit_card_outlined,
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
    String initialValue = '',
  }) {
    // Set the initial value if controller is empty
    if (controller.text.isEmpty && initialValue.isNotEmpty) {
      controller.text = initialValue;
    }

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: enabled ? Colors.green : Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !enabled,
        fillColor: enabled ? Colors.transparent : Colors.grey[50],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        labelStyle: TextStyle(
          color: enabled ? Colors.green : Colors.grey[600],
        ),
        hintText: initialValue.isEmpty ? 'Not set' : null,
      ),
      style: TextStyle(
        color: enabled ? Colors.black87 : Colors.grey[600],
      ),
      validator: (value) {
        if (enabled && value != null && value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'Not set',
                  style: TextStyle(
                    fontSize: 16,
                    color: value.isNotEmpty ? Colors.black87 : Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getUserTypeDisplay() {
    if (user == null) return 'Not set';
    
    final userType = user!['user_type'];
    
    switch (userType) {
      case 'customer':
        return 'Customer';
      case 'vendor':
        return 'Vendor';
      case 'delivery':
        return 'Delivery Partner';
      default:
        return 'Customer';
    }
  }
}