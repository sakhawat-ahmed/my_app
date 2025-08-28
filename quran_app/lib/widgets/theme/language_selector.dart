import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('App Language'),
      subtitle: Text(themeProvider.currentLanguageName),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showLanguageDialog(context, themeProvider);
      },
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
}