import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class ProfileHeader extends StatelessWidget {
  final bool isEditing;

  const ProfileHeader({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: ResponsiveUtils.responsiveSize(context, mobile: 100, tablet: 120, desktop: 140),
              height: ResponsiveUtils.responsiveSize(context, mobile: 100, tablet: 120, desktop: 140),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[100],
                border: Border.all(
                  color: Colors.green,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.person,
                size: ResponsiveUtils.responsiveSize(context, mobile: 50, tablet: 60, desktop: 70),
                color: Colors.green,
              ),
            ),
            if (isEditing)
              Container(
                width: ResponsiveUtils.responsiveSize(context, mobile: 32, tablet: 36, desktop: 40),
                height: ResponsiveUtils.responsiveSize(context, mobile: 32, tablet: 36, desktop: 40),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 20, desktop: 22),
                  color: Colors.white,
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        Text(
          'John Doe',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
        Text(
          'Premium Member',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}