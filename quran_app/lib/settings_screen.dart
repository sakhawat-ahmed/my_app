import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

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
              ListTile(
                leading: const Icon(Icons.nightlight_round),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Text Size'),
                subtitle: Text(themeProvider.currentTextSizeName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showTextSizeDialog(context, themeProvider);
                },
              ),
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
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('App Language'),
                subtitle: Text(themeProvider.currentLanguageName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showLanguageDialog(context, themeProvider);
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Other Settings
        Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Other',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.volume_up),
                title: const Text('Audio Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // App Settings
        Card(
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Clear Cache'),
                onTap: () {
                  _showClearCacheDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Check for Updates'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                onTap: () {},
              ),
            ],
          ),
        ),

        // Text Size Preview
Card(
  elevation: 2,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text Size Preview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ',
          style: TextStyle(
            fontSize: 20 * themeProvider.textSizeFactor,
            fontWeight: FontWeight.bold,
            fontFamily: "Amiri",
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Text(
          'আল্লাহর নামে শুরু করছি যিনি পরম করুণাময়, অতি দয়ালু।',
          style: TextStyle(
            fontSize: 16 * themeProvider.textSizeFactor,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    ),
  ),
),
      ],
    );
  }

  void _showTextSizeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Text Size'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: themeProvider.textSizeOptions.length,
            itemBuilder: (context, index) {
              final sizeName = themeProvider.textSizeOptions[index];
              final sizeFactor = ThemeProvider.textSizePresets[sizeName]!;
              
              return ListTile(
                title: Text(sizeName),
                subtitle: Text(
                  'Example: ${(16 * sizeFactor).toStringAsFixed(1)}pt',
                  style: TextStyle(fontSize: 14 * sizeFactor),
                ),
                trailing: themeProvider.textSizeFactor == sizeFactor
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  themeProvider.changeTextSizeByName(sizeName);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Text size changed to $sizeName'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: themeProvider.availableLanguages.length,
            itemBuilder: (context, index) {
              final languageCode = themeProvider.availableLanguages[index];
              final languageName = themeProvider.languageNames[languageCode]!;
              
              return ListTile(
                title: Text(languageName),
                trailing: themeProvider.currentLanguage == languageCode
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  themeProvider.changeLanguage(languageCode);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language changed to $languageName'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}