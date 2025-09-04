import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_provider.dart';

class LanguageSettings extends StatelessWidget {
  final ThemeProvider themeProvider;

  const LanguageSettings({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  _changeLanguage(context, languageCode, languageName);
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

  void _changeLanguage(BuildContext context, String languageCode, String languageName) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    // Change the language in the provider
    await themeProvider.changeLanguage(languageCode);
    
    // Close the dialog
    Navigator.pop(context);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to $languageName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}