import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class RegisterUserTypeSelector extends StatelessWidget {
  final String selectedUserType;
  final Function(String) onUserTypeChanged;

  const RegisterUserTypeSelector({
    super.key,
    required this.selectedUserType,
    required this.onUserTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
        Row(
          children: [
            Expanded(
              child: _buildUserTypeCard(
                type: 'customer',
                title: 'Customer',
                description: 'Shop for groceries',
                icon: Icons.shopping_cart,
                color: Colors.green,
              ),
            ),
            SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
            Expanded(
              child: _buildUserTypeCard(
                type: 'vendor',
                title: 'Vendor',
                description: 'Sell products',
                icon: Icons.store,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTypeCard({
    required String type,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedUserType == type;

    return GestureDetector(
      onTap: () => onUserTypeChanged(type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? color : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}