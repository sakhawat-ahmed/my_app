import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/theme_provider.dart';
import 'package:timer_app/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: themeProvider.setTheme,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text('Enable Vibration'),
            value: settingsProvider.vibrationEnabled,
            onChanged: settingsProvider.setVibrationEnabled,
          ),
          SwitchListTile(
            title: Text('Enable Sound'),
            value: settingsProvider.soundEnabled,
            onChanged: settingsProvider.setSoundEnabled,
          ),
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: settingsProvider.notificationsEnabled,
            onChanged: settingsProvider.setNotificationsEnabled,
          ),
          ListTile(
            title: Text('Notification Sound'),
            trailing: DropdownButton<String>(
              value: settingsProvider.selectedSound,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setSelectedSound(value);
                }
              },
              items: [
                'alarm',
                'beep',
                'chime',
                'ring',
              ].map((sound) {
                return DropdownMenuItem(
                  value: sound,
                  child: Text(sound),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}