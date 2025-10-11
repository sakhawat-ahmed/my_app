import 'package:flutter/material.dart';
import 'package:grocery_app/screens/help_support_screen.dart';
import 'package:grocery_app/screens/notifications_screen.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 32),
            _buildSettingsContent(context, themeProvider, isDarkMode),
            const SizedBox(height: 24),
            const AppVersionCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, ThemeProvider themeProvider, bool isDarkMode) {
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
  ) {
    return items.map((item) {
      return SettingsItemTile(
        item: item,
        isDarkMode: isDarkMode,
        switchValue: item.id == 'dark_mode' ? themeProvider.isDarkMode : false,
        onTap: () => _handleItemTap(context, item),
        onSwitchChanged: item.id == 'dark_mode'
            ? (value) => themeProvider.toggleTheme()
            : null,
      );
    }).toList();
  }

  void _handleItemTap(BuildContext context, SettingItem item) {
    // Handle navigation based on item.id
    switch (item.id) {
      case 'notifications':
         Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
        break;
      case 'help_support':
         Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
        break;
      // Add more cases for other navigation items
    }
  }
}