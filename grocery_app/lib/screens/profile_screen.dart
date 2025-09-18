import 'package:flutter/material.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/widgets/profile/profile_header.dart';
import 'package:grocery_app/widgets/profile/personal_info_form.dart';
import 'package:grocery_app/widgets/profile/preferences_section.dart';
import 'package:grocery_app/widgets/profile/account_actions.dart';
import 'package:grocery_app/widgets/profile/save_button.dart';
import 'package:grocery_app/services/auth_services.dart';
import 'package:grocery_app/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = true;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        setState(() {
          _currentUser = user;
          _nameController.text = user.name;
          _emailController.text = user.email;
          _phoneController.text = user.phone;
          _addressController.text = user.address ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _currentUser!.password,
        address: _addressController.text.trim(),
        createdAt: _currentUser!.createdAt,
      );

      final success = await AuthService.updateUser(updatedUser);

      if (success) {
        setState(() {
          _isEditing = false;
          _currentUser = updatedUser;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _performLogout() async {
    try {
      await AuthService.logout();
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error logging out'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                _performLogout();
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

  void _handleLanguageTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Language selection'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleOrderHistoryTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order history'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handlePaymentMethodsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment methods'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleHelpSupportTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & support'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                  // Reset to original values
                  _nameController.text = _currentUser?.name ?? '';
                  _emailController.text = _currentUser?.email ?? '';
                  _phoneController.text = _currentUser?.phone ?? '';
                  _addressController.text = _currentUser?.address ?? '';
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
            ProfileHeader(isEditing: _isEditing, user: _currentUser),
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
                onPressed: _saveProfile,
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
}