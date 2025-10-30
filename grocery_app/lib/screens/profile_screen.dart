import 'package:flutter/material.dart';
import 'package:grocery_app/services/api_service.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/widgets/profile/profile_header.dart';
import 'package:grocery_app/widgets/profile/personal_info_form.dart';
import 'package:grocery_app/widgets/profile/preferences_section.dart';
import 'package:grocery_app/widgets/profile/account_actions.dart';
import 'package:grocery_app/widgets/profile/save_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  const ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  Map<String, dynamic>? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Use the user passed from parent or fetch from API
      if (widget.user != null) {
        _currentUser = widget.user;
      } else {
        final user = await ApiService.getCurrentUser();
        _currentUser = user;
      }

      if (_currentUser != null) {
        setState(() {
          _firstNameController.text = _currentUser!['first_name'] ?? '';
          _lastNameController.text = _currentUser!['last_name'] ?? '';
          _emailController.text = _currentUser!['email'] ?? '';
          _phoneController.text = _currentUser!['phone'] ?? '';
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
      _showErrorSnackBar('Failed to load user data: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_currentUser != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare user data for API call
        final userData = {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
        };

        // Remove empty fields
        userData.removeWhere((key, value) => value.isEmpty);

        final result = await ApiService.updateUserProfile(userData);

        if (result['success'] == true) {
          // Update local user data
          _currentUser = {
            ..._currentUser!,
            ...userData,
          };
          
          setState(() {
            _isEditing = false;
            _isLoading = false;
          });
          
          _showSuccessSnackBar(result['data']['message'] ?? 'Profile updated successfully');
        } else {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar(result['error'] ?? 'Failed to update profile');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Error updating profile: $e');
      }
    }
  }

  void _performLogout() async {
    try {
      await ApiService.logout();
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      
      _showSuccessSnackBar('Logged out successfully');
    } catch (e) {
      _showErrorSnackBar('Error logging out: $e');
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(context);

    if (_isLoading && _currentUser == null) {
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
          if (!_isEditing && _currentUser != null)
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
                  _loadUserData();
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: padding,
              child: Column(
                children: [
                  // Profile Header
                  ProfileHeader(
                    isEditing: _isEditing, 
                    user: _currentUser,
                  ),
                  SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 32, desktop: 40)),

                  // Personal Information
                  _buildSectionTitle('Personal Information'),
                  SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
               // In your ProfileScreen build method, update the PersonalInfoForm:
PersonalInfoForm(
  isEditing: _isEditing,
  firstNameController: _firstNameController,
  lastNameController: _lastNameController,
  emailController: _emailController,
  phoneController: _phoneController,
  addressController: _addressController,
  user: _currentUser, 
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 20, desktop: 22),
          fontWeight: FontWeight.bold,
          color: themeProvider.textColor,
        ),
      ),
    );
  }
}