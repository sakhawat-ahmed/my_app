import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.person_add,
          size: ResponsiveUtils.responsiveSize(context, mobile: 60, tablet: 80, desktop: 100),
          color: Colors.green,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
        Text(
          'Join us and start shopping',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}