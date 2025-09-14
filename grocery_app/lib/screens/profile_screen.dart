import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

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
    final isMobile = ResponsiveUtils.isMobile(context);
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
            _buildProfileHeader(),
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 32, desktop: 40)),

            // Personal Information
            _buildSectionTitle('Personal Information'),
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
            _buildPersonalInfoForm(),

            // Preferences
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 32, tablet: 40, desktop: 48)),
            _buildSectionTitle('Preferences'),
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
            _buildPreferences(),

            // Account Actions
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 32, tablet: 40, desktop: 48)),
            _buildSectionTitle('Account'),
            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
            _buildAccountActions(),

            // Save Button when editing
            if (_isEditing) ...[
              SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 32, tablet: 40, desktop: 48)),
              _buildSaveButton(),
            ],

            SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 30, desktop: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
            if (_isEditing)
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

  Widget _buildPersonalInfoForm() {
    return Column(
      children: [
        _buildEditableField(
          label: 'Full Name',
          controller: _nameController,
          icon: Icons.person,
          enabled: _isEditing,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildEditableField(
          label: 'Email Address',
          controller: _emailController,
          icon: Icons.email,
          enabled: _isEditing,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildEditableField(
          label: 'Phone Number',
          controller: _phoneController,
          icon: Icons.phone,
          enabled: _isEditing,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildEditableField(
          label: 'Delivery Address',
          controller: _addressController,
          icon: Icons.location_on,
          enabled: _isEditing,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !enabled,
        fillColor: enabled ? Colors.transparent : Colors.grey[100],
      ),
    );
  }

  Widget _buildPreferences() {
    return Column(
      children: [
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Receive order updates and promotions',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildSwitchTile(
          title: 'Dark Mode',
          subtitle: 'Switch to dark theme',
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildListTile(
          title: 'Language',
          subtitle: 'English',
          icon: Icons.language,
          onTap: () {
            // Language selection
          },
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: Colors.grey[600],
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function() onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
          size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAccountActions() {
    return Column(
      children: [
        _buildActionTile(
          title: 'Order History',
          icon: Icons.history,
          onTap: () {
            // Navigate to order history
          },
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        _buildActionTile(
          title: 'Payment Methods',
          icon: Icons.credit_card,
          onTap: () {
            // Navigate to payment methods
          },
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        _buildActionTile(
          title: 'Help & Support',
          icon: Icons.help_center,
          onTap: () {
            // Navigate to help center
          },
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        _buildActionTile(
          title: 'Logout',
          icon: Icons.logout,
          color: Colors.red,
          onTap: () {
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required IconData icon,
    Color color = Colors.green,
    required Function() onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: color,
          size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Save Changes',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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