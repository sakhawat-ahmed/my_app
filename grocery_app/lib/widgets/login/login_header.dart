import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.shopping_cart,
          size: ResponsiveUtils.responsiveSize(context, mobile: 80, tablet: 100, desktop: 120),
          color: Colors.green,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
        Text(
          'Sign in to continue shopping',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}