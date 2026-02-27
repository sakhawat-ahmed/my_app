import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/services/auth_services.dart';

class PreferencesSection extends StatelessWidget {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onDarkModeChanged;
  final VoidCallback onLanguageTap;

  const PreferencesSection({
    super.key,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.onNotificationsChanged,
    required this.onDarkModeChanged,
    required this.onLanguageTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        _buildSwitchTile(
          context: context,
          title: 'Push Notifications',
          subtitle: 'Receive order updates and promotions',
          value: notificationsEnabled,
          onChanged: onNotificationsChanged,
          themeProvider: themeProvider,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildSwitchTile(
          context: context,
          title: 'Dark Mode',
          subtitle: 'Switch to dark theme',
          value: themeProvider.isDarkMode,
          onChanged: (value) async {
            themeProvider.setTheme(value);
            await AuthService.saveThemePreference(value);
            onDarkModeChanged(value);
          },
          themeProvider: themeProvider,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildListTile(
          context: context,
          title: 'Language',
          subtitle: 'English',
          icon: Icons.language,
          onTap: onLanguageTap,
          themeProvider: themeProvider,
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w500,
            color: themeProvider.textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: themeProvider.secondaryTextColor,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.green,
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Function() onTap,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w500,
            color: themeProvider.textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: themeProvider.secondaryTextColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: themeProvider.secondaryTextColor,
          size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
        ),
        onTap: onTap,
      ),
    );
  }
}