import 'package:flutter/material.dart';
import 'package:quran_app/widgets/theme/theme_switcher.dart';
import 'package:quran_app/widgets/theme/text_size_selector.dart';
import 'package:quran_app/widgets/theme/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        // Appearance Settings
        Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Appearance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const ThemeSwitcher(),
              const TextSizeSelector(),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Language Settings
        Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const LanguageSelector(),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }
}