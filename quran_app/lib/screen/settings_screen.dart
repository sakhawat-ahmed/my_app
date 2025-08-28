import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/widgets/settings/appearance_settings.dart';
import 'package:quran_app/widgets/settings/language_settings.dart';
import 'package:quran_app/widgets/settings/other_settings.dart';
import 'package:quran_app/widgets/settings/app_settings.dart';
import 'package:quran_app/widgets/settings/text_preview.dart';
import '../theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        // Appearance Settings
        AppearanceSettings(themeProvider: themeProvider),
        
        const SizedBox(height: 20),
        
        // Language Settings
        LanguageSettings(themeProvider: themeProvider),
        
        const SizedBox(height: 20),
        
        // Other Settings
        const OtherSettings(),
        
        const SizedBox(height: 20),
        
        // App Settings
        const AppSettings(),
        
        const SizedBox(height: 20),
        
        // Text Size Preview
        TextPreview(themeProvider: themeProvider),
      ],
    );
  }
}