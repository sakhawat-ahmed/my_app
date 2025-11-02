import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 22, desktop: 24),
                width: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 22, desktop: 24),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Login',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}