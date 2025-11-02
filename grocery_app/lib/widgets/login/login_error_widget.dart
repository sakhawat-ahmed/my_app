import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class LoginErrorWidget extends StatelessWidget {
  final String errorMessage;

  const LoginErrorWidget({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16)),
      margin: EdgeInsets.only(bottom: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 10, desktop: 12)),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 15, desktop: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}