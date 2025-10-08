import 'package:flutter/material.dart';
import 'package:grocery_app/screens/help_support_screen.dart';
import 'package:grocery_app/screens/notifications_screen.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/widgets/setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final padding = ResponsiveUtils.responsivePadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding.left),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSectionTitle('Account Settings'),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  SettingTile(
                    icon: Icons.person,
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    onTap: () {
                      // Navigate to edit profile screen
                    },
                  ),
                  SettingTile(
                    icon: Icons.location_on,
                    title: 'Delivery Address',
                    subtitle: 'Manage your delivery locations',
                    onTap: () {
                      // Navigate to address management
                    },
                  ),
                  SettingTile(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Add or remove payment options',
                    onTap: () {
                      // Navigate to payment methods
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App Preferences
            _buildSectionTitle('App Preferences'),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  SettingTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage your notification preferences',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      );
                    },
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return SwitchListTile(
                        leading: const Icon(Icons.dark_mode, color: Colors.green),
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Switch between light and dark theme'),
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      );
                    },
                  ),
                  SettingTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English (US)',
                    onTap: () {
                      _showLanguageDialog(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Privacy & Security
            _buildSectionTitle('Privacy & Security'),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  SettingTile(
                    icon: Icons.lock,
                    title: 'Privacy Policy',
                    subtitle: 'View our privacy practices',
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                  SettingTile(
                    icon: Icons.security,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms and conditions',
                    onTap: () {
                      // Navigate to terms of service
                    },
                  ),
                  SettingTile(
                    icon: Icons.delete,
                    title: 'Delete Account',
                    subtitle: 'Permanently remove your account',
                    onTap: () {
                      _showDeleteAccountDialog(context);
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Support
            _buildSectionTitle('Support'),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  SettingTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help with the app',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                      );
                    },
                  ),
                  SettingTile(
                    icon: Icons.bug_report,
                    title: 'Report a Bug',
                    subtitle: 'Found an issue? Let us know',
                    onTap: () {
                      _showBugReportDialog(context);
                    },
                  ),
                  SettingTile(
                    icon: Icons.star,
                    title: 'Rate App',
                    subtitle: 'Share your experience',
                    onTap: () {
                      // Rate app functionality
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // App Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English (US)'),
                trailing: const Icon(Icons.check, color: Colors.green),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Spanish'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement language change
                },
              ),
              ListTile(
                title: const Text('French'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement language change
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement account deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion feature coming soon'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report a Bug'),
          content: const Text('Please describe the issue you encountered:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}