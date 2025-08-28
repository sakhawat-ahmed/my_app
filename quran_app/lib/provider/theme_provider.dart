import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _currentLanguage = 'en'; 
  double _textSizeFactor = 1.0; 
  final Map<String, String> _languageNames = {
    'bn': 'বাংলা (Bengali)',
    'en': 'English',
    'ar': 'العربية (Arabic)',
    'ur': 'اردو (Urdu)',
  };

  // Text size presets
  static const Map<String, double> textSizePresets = {
    'Small': 0.8,
    'Medium': 1.0,
    'Large': 1.2,
    'Extra Large': 1.4,
  };

  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;
  String get currentLanguageName => _languageNames[_currentLanguage] ?? 'English';
  double get textSizeFactor => _textSizeFactor;
  String get currentTextSizeName => _getTextSizeName(_textSizeFactor);
  List<String> get availableLanguages => _languageNames.keys.toList();
  Map<String, String> get languageNames => _languageNames;
  List<String> get textSizeOptions => textSizePresets.keys.toList();

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

  void changeTextSize(double factor) {
    _textSizeFactor = factor;
    notifyListeners();
  }

  void changeTextSizeByName(String sizeName) {
    if (textSizePresets.containsKey(sizeName)) {
      _textSizeFactor = textSizePresets[sizeName]!;
      notifyListeners();
    }
  }

  String _getTextSizeName(double factor) {
    for (var entry in textSizePresets.entries) {
      if (entry.value == factor) {
        return entry.key;
      }
    }
    return 'Medium';
  }

  // Light theme with proper text colors
  ThemeData get _lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: Colors.green,
      colorScheme: const ColorScheme.light(
        primary: Colors.green,
        secondary: Colors.green,
        onBackground: Colors.black87,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16.0 * _textSizeFactor,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0 * _textSizeFactor,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontSize: 12.0 * _textSizeFactor,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 22.0 * _textSizeFactor,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 18.0 * _textSizeFactor,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          fontSize: 16.0 * _textSizeFactor,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        displayLarge: TextStyle(
          fontSize: 24.0 * _textSizeFactor,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontSize: 20.0 * _textSizeFactor,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontSize: 18.0 * _textSizeFactor,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Dark theme
  ThemeData get _darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.green[700],
      colorScheme: ColorScheme.dark(
        primary: Colors.green[700]!,
        secondary: Colors.greenAccent,
        onBackground: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: CardThemeData(
        elevation: 4,
        color: const Color(0xFF1E1E1E),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16.0 * _textSizeFactor,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0 * _textSizeFactor,
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontSize: 12.0 * _textSizeFactor,
          color: Colors.white70,
        ),
        titleLarge: TextStyle(
          fontSize: 22.0 * _textSizeFactor,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 18.0 * _textSizeFactor,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          fontSize: 16.0 * _textSizeFactor,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displayLarge: TextStyle(
          fontSize: 24.0 * _textSizeFactor,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontSize: 20.0 * _textSizeFactor,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontSize: 18.0 * _textSizeFactor,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}