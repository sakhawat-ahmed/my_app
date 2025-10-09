import 'dart:ui';

class SettingItem {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final int iconColor;
  final bool hasNavigation;
  final bool hasSwitch;
  final String? routeName;

  const SettingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.hasNavigation = false,
    this.hasSwitch = false,
    this.routeName,
  });

  Color get color => Color(iconColor);
}