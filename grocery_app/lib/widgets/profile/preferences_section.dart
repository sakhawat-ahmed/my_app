import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

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
    return Column(
      children: [
        _buildSwitchTile(
          context: context,
          title: 'Push Notifications',
          subtitle: 'Receive order updates and promotions',
          value: notificationsEnabled,
          onChanged: onNotificationsChanged,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildSwitchTile(
          context: context,
          title: 'Dark Mode',
          subtitle: 'Switch to dark theme',
          value: darkModeEnabled,
          onChanged: onDarkModeChanged,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildListTile(
          context: context,
          title: 'Language',
          subtitle: 'English',
          icon: Icons.language,
          onTap: onLanguageTap,
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
    required BuildContext context,
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
}