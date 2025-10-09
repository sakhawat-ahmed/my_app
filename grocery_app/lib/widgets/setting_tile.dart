import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  final List<Color>? gradient;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: gradient != null
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient!,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: gradient != null
                        ? Colors.white.withOpacity(0.2)
                        : (isDestructive
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: gradient != null
                        ? Colors.white
                        : (isDestructive ? Colors.red : Colors.green),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: gradient != null
                              ? Colors.white
                              : (isDestructive ? Colors.red : Colors.black),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: gradient != null
                              ? Colors.white.withOpacity(0.8)
                              : (isDestructive
                                  ? Colors.red.withOpacity(0.7)
                                  : Colors.grey[600]),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: gradient != null
                      ? Colors.white
                      : (isDestructive ? Colors.red : Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}