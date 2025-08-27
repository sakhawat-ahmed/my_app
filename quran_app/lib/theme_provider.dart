import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _currentLanguage = 'bn'; // Default to Bengali
  final Map<String, String> _languageNames = {
    'bn': 'বাংলা (Bengali)',
    'en': 'English',
    'ar': 'العربية (Arabic)',
    'ur': 'اردو (Urdu)',
  };

  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;
  String get currentLanguageName => _languageNames[_currentLanguage] ?? 'Bengali';
  List<String> get availableLanguages => _languageNames.keys.toList();
  Map<String, String> get languageNames => _languageNames;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void changeLanguage(String languageCode) {
    if (_languageNames.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      notifyListeners();
    }
  }

  // Light theme
  ThemeData get _lightTheme => ThemeData.light().copyWith(
        primaryColor: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      );

  // Dark theme
  ThemeData get _darkTheme => ThemeData.dark().copyWith(
        primaryColor: Colors.green[700],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
        ),
      );
}