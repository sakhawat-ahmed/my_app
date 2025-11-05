import 'package:flutter/material.dart';
import 'package:grocery_app/screens/help_support_screen.dart';
import 'package:grocery_app/screens/notifications_screen.dart';
import 'package:grocery_app/screens/edit_profile_screen.dart';
import 'package:grocery_app/screens/change_password_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/providers/user_provider.dart';
import 'package:grocery_app/data/settings_data.dart';
import 'package:grocery_app/models/setting_item.dart';
import 'package:grocery_app/widgets/settings/profile_header.dart';
import 'package:grocery_app/widgets/settings/settings_section.dart';
import 'package:grocery_app/widgets/settings/settings_item_tile.dart';
import 'package:grocery_app/widgets/settings/app_version_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: userProvider.isLoggedIn
          ? _buildSettingsContent(context, themeProvider, userProvider, isDarkMode)
          : _buildLoginPrompt(context),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Please login to access settings',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context,
    ThemeProvider themeProvider,
    UserProvider userProvider,
    bool isDarkMode,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ProfileHeader(),
          const SizedBox(height: 32),
          _buildSettingsSections(context, themeProvider, userProvider, isDarkMode),
          const SizedBox(height: 24),
          const AppVersionCard(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingsSections(
    BuildContext context,
    ThemeProvider themeProvider,
    UserProvider userProvider,
    bool isDarkMode,
  ) {
    return Column(
      children: [
        // Account Section
        SettingsSection(
          title: 'Account',
          children: _buildSettingItems(
            context,
            SettingsData.accountSettings,
            isDarkMode,
            themeProvider,
            userProvider,
          ),
        ),
        const SizedBox(height: 24),

        // Preferences Section
        SettingsSection(
          title: 'Preferences',
          children: _buildSettingItems(
            context,
            SettingsData.preferenceSettings,
            isDarkMode,
            themeProvider,
            userProvider,
          ),
        ),
        const SizedBox(height: 24),

        // Support Section
        SettingsSection(
          title: 'Support',
          children: _buildSettingItems(
            context,
            SettingsData.supportSettings,
            isDarkMode,
            themeProvider,
            userProvider,
          ),
        ),
        const SizedBox(height: 24),

        // Legal Section
        SettingsSection(
          title: 'Legal',
          children: _buildSettingItems(
            context,
            SettingsData.legalSettings,
            isDarkMode,
            themeProvider,
            userProvider,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSettingItems(
    BuildContext context,
    List<SettingItem> items,
    bool isDarkMode,
    ThemeProvider themeProvider,
    UserProvider userProvider,
  ) {
    return items.map((item) {
      return SettingsItemTile(
        item: item,
        isDarkMode: isDarkMode,
        switchValue: item.id == 'dark_mode' ? themeProvider.isDarkMode : false,
        onTap: () => _handleItemTap(context, item, userProvider),
        onSwitchChanged: item.id == 'dark_mode'
            ? (value) => themeProvider.toggleTheme()
            : null,
      );
    }).toList();
  }

  void _handleItemTap(BuildContext context, SettingItem item, UserProvider userProvider) {
    switch (item.id) {
      case 'edit_profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
        );
        break;
      case 'change_password':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
        );
        break;
      case 'notifications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
        break;
      case 'help_support':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
        );
        break;
      case 'logout':
        _showLogoutDialog(context, userProvider);
        break;
      // Add more cases for other navigation items
    }
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                userProvider.logout();
                // Navigate to login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}