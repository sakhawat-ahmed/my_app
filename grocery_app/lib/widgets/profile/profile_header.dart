import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class ProfileHeader extends StatelessWidget {
  final bool isEditing;
  final Map<String, dynamic>? user;

  const ProfileHeader({super.key, required this.isEditing, this.user});

  @override
  Widget build(BuildContext context) {
    final userName = _getUserName();
    final userEmail = user?['email'] ?? 'No email';
    final memberSince = _getMemberSince();
    final userType = _getUserTypeDisplay();

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
                color: _getUserColor(),
                border: Border.all(
                  color: _getUserBorderColor(),
                  width: 3,
                ),
              ),
              child: Icon(
                _getUserIcon(),
                size: ResponsiveUtils.responsiveSize(context, mobile: 50, tablet: 60, desktop: 70),
                color: Colors.white,
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
        
        // User Name
        Text(
          userName,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
        
        // Email
        Text(
          userEmail,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
        
        // User Type Badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
            vertical: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8),
          ),
          decoration: BoxDecoration(
            color: _getUserTypeColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            userType,
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 13, desktop: 14),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
        
        // Member Since
        Text(
          memberSince,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16),
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  String _getUserName() {
    if (user == null) return 'Guest User';
    
    final firstName = user!['first_name'] ?? '';
    final lastName = user!['last_name'] ?? '';
    final username = user!['username'] ?? '';
    
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    } else if (username.isNotEmpty) {
      return username;
    }
    
    return 'User';
  }

  String _getMemberSince() {
    if (user == null) return 'Member since Unknown';
    
    final dateJoined = user!['date_joined'];
    if (dateJoined != null) {
      try {
        final date = DateTime.parse(dateJoined);
        return 'Member since ${_formatDate(date)}';
      } catch (e) {
        return 'Member since Unknown';
      }
    }
    
    return 'Member since Unknown';
  }

  String _getUserTypeDisplay() {
    if (user == null) return 'Guest';
    
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

  Color _getUserColor() {
    if (user == null) return Colors.grey[400]!;
    
    final userType = user!['user_type'];
    
    switch (userType) {
      case 'customer':
        return Colors.green;
      case 'vendor':
        return Colors.blue;
      case 'delivery':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Color _getUserBorderColor() {
    if (user == null) return Colors.grey[600]!;
    
    final userType = user!['user_type'];
    
    switch (userType) {
      case 'customer':
        return Colors.green[800]!;
      case 'vendor':
        return Colors.blue[800]!;
      case 'delivery':
        return Colors.orange[800]!;
      default:
        return Colors.green[800]!;
    }
  }

  Color _getUserTypeColor() {
    if (user == null) return Colors.grey;
    
    final userType = user!['user_type'];
    
    switch (userType) {
      case 'customer':
        return Colors.green;
      case 'vendor':
        return Colors.blue;
      case 'delivery':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _getUserIcon() {
    if (user == null) return Icons.person;
    
    final userType = user!['user_type'];
    
    switch (userType) {
      case 'customer':
        return Icons.person;
      case 'vendor':
        return Icons.store;
      case 'delivery':
        return Icons.delivery_dining;
      default:
        return Icons.person;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}