import 'package:flutter/material.dart';
import 'package:grocery_app/models/setting_item.dart';

class SettingsData {
  static final List<SettingItem> accountSettings = [
    const SettingItem(
      id: 'edit_profile',
      title: 'Edit Profile',
      subtitle: 'Update your personal information',
      icon: 'person_outline',
      iconColor: 0xFF4285F4,
      hasNavigation: true,
    ),
    const SettingItem(
      id: 'delivery_address',
      title: 'Delivery Address',
      subtitle: 'Manage your delivery locations',
      icon: 'location_on_outlined',
      iconColor: 0xFF34A853,
      hasNavigation: true,
    ),
    const SettingItem(
      id: 'payment_methods',
      title: 'Payment Methods',
      subtitle: 'Add or remove payment options',
      icon: 'payment_outlined',
      iconColor: 0xFFFBBC05,
      hasNavigation: true,
    ),
  ];

  static final List<SettingItem> preferenceSettings = [
    const SettingItem(
      id: 'notifications',
      title: 'Notifications',
      subtitle: 'Manage your notification preferences',
      icon: 'notifications_outlined',
      iconColor: 0xFF9C27B0,
      hasNavigation: true,
    ),
    const SettingItem(
      id: 'dark_mode',
      title: 'Dark Mode',
      subtitle: 'Switch between light and dark theme',
      icon: 'dark_mode_outlined',
      iconColor: 0xFF3F51B5,
      hasSwitch: true,
    ),
    const SettingItem(
      id: 'language',
      title: 'Language',
      subtitle: 'English (US)',
      icon: 'language_outlined',
      iconColor: 0xFF009688,
      hasNavigation: true,
    ),
  ];

  static final List<SettingItem> supportSettings = [
    const SettingItem(
      id: 'help_support',
      title: 'Help & Support',
      subtitle: 'Get help with the app',
      icon: 'help_outline',
      iconColor: 0xFF607D8B,
      hasNavigation: true,
    ),
    const SettingItem(
      id: 'report_bug',
      title: 'Report a Bug',
      subtitle: 'Found an issue? Let us know',
      icon: 'bug_report_outlined',
      iconColor: 0xFFF44336,
      hasNavigation: true,
    ),
    const SettingItem(
      id: 'rate_app',
      title: 'Rate App',
      subtitle: 'Share your experience',
      icon: 'star_outline',
      iconColor: 0xFFFF9800,
      hasNavigation: true,
    ),
  ];

  static final List<SettingItem> legalSettings = [
    const SettingItem(
      id: 'privacy_policy',
      title: 'Privacy Policy',
      subtitle: 'View our privacy practices',
      icon: 'privacy_tip_outlined',
      iconColor: 0xFF757575,
      hasNavigation: true,
    ),
    const SettingItem(
      id: 'terms_service',
      title: 'Terms of Service',
      subtitle: 'Read our terms and conditions',
      icon: 'description_outlined',
      iconColor: 0xFF757575,
      hasNavigation: true,
    ),
  ];
}