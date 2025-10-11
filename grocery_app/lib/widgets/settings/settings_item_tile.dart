import 'package:flutter/material.dart';
import 'package:grocery_app/models/setting_item.dart';

class SettingsItemTile extends StatelessWidget {
  final SettingItem item;
  final bool isDarkMode;
  final bool switchValue;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSwitchChanged;

  const SettingsItemTile({
    super.key,
    required this.item,
    required this.isDarkMode,
    this.switchValue = false,
    this.onTap,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getIconData(item.icon),
                  color: item.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (item.hasNavigation)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              if (item.hasSwitch)
                Switch(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                  activeColor: Colors.green,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person_outline':
        return Icons.person_outline;
      case 'location_on_outlined':
        return Icons.location_on_outlined;
      case 'payment_outlined':
        return Icons.payment_outlined;
      case 'notifications_outlined':
        return Icons.notifications_outlined;
      case 'dark_mode_outlined':
        return Icons.dark_mode_outlined;
      case 'language_outlined':
        return Icons.language_outlined;
      case 'help_outline':
        return Icons.help_outline;
      case 'bug_report_outlined':
        return Icons.bug_report_outlined;
      case 'star_outline':
        return Icons.star_outline;
      case 'privacy_tip_outlined':
        return Icons.privacy_tip_outlined;
      case 'description_outlined':
        return Icons.description_outlined;
      default:
        return Icons.settings_outlined;
    }
  }
}