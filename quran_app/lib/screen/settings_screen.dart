import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_provider.dart';
import 'package:quran_app/screen/language_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LanguageSettings(themeProvider: themeProvider),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: themeProvider.isDarkMode,
                onChanged: themeProvider.toggleTheme,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Text Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Text Size:'),
                    Text(themeProvider.currentTextSizeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Slider(
                value: themeProvider.textSizeFactor,
                min: 0.8,
                max: 1.4,
                divisions: 3,
                label: themeProvider.currentTextSizeName,
                onChanged: themeProvider.changeTextSize,
              ),
            ],
          ),
        ),
      ],
    );
  }
}