import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final bool isEditing;
  final User? user;

  const ProfileHeader({super.key, required this.isEditing, this.user});

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
          user?.name ?? 'User Name',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
        Text(
          user?.email ?? 'user@example.com',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
        Text(
          'Member since ${_formatDate(user?.createdAt)}',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16),
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }
}