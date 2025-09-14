import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/widgets/profile/profile_header.dart';
import 'package:grocery_app/widgets/profile/personal_info_form.dart';
import 'package:grocery_app/widgets/profile/preferences_section.dart';
import 'package:grocery_app/widgets/profile/account_actions.dart';
import 'package:grocery_app/widgets/profile/save_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'John Doe');
  final TextEditingController _emailController = TextEditingController(text: 'john.doe@example.com');
  final TextEditingController _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final TextEditingController _addressController = TextEditingController(text: '123 Main St, City, State 12345');

  bool _isEditing = false;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: ResponsiveUtils.titleFontSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(
                Icons.edit,
                size: ResponsiveUtils.responsiveSize(context, mobile: 22, tablet: 24, desktop: 26),
              ),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(
                Icons.close,
                size: ResponsiveUtils.responsiveSize(context, mobile: 22, tablet: 24, desktop: 26),
              ),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: padding,
        child: Column(
          children: [
            // Profile Header
            ProfileHeader(isEditing: _isEditing),
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 32, desktop: 40)),

            // Personal Information
            _buildSectionTitle('Personal Information'),
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
            PersonalInfoForm(
              isEditing: _isEditing,
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              addressController: _addressController,
            ),

            // Preferences
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 32, tablet: 40, desktop: 48)),
            _buildSectionTitle('Preferences'),
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
            PreferencesSection(
              notificationsEnabled: _notificationsEnabled,
              darkModeEnabled: _darkModeEnabled,
              onNotificationsChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              onDarkModeChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
              onLanguageTap: _handleLanguageTap,
            ),

            // Account Actions
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 32, tablet: 40, desktop: 48)),
            _buildSectionTitle('Account'),
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
            AccountActions(
              onOrderHistoryTap: _handleOrderHistoryTap,
              onPaymentMethodsTap: _handlePaymentMethodsTap,
              onHelpSupportTap: _handleHelpSupportTap,
              onLogoutTap: _showLogoutDialog,
            ),

            // Save Button when editing
            if (_isEditing) ...[
              SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 32, tablet: 40, desktop: 48)),
              SaveButton(
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ],

            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 30, desktop: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 20, desktop: 22),
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  void _handleLanguageTap() {
    // Language selection logic
    print('Language tap');
  }

  void _handleOrderHistoryTap() {
    // Navigate to order history
    print('Order history tap');
  }

  void _handlePaymentMethodsTap() {
    // Navigate to payment methods
    print('Payment methods tap');
  }

  void _handleHelpSupportTap() {
    // Navigate to help center
    print('Help & support tap');
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 20, desktop: 22),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Perform logout logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}