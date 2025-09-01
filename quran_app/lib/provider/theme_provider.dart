import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  ThemeProvider() {
    _loadPreferences();
  }

  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;
  String get currentLanguageName => _languageNames[_currentLanguage] ?? 'English';
  double get textSizeFactor => _textSizeFactor;
  String get currentTextSizeName => _getTextSizeName(_textSizeFactor);
  List<String> get availableLanguages => _languageNames.keys.toList();
  Map<String, String> get languageNames => _languageNames;
  List<String> get textSizeOptions => textSizePresets.keys.toList();

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _currentLanguage = prefs.getString('language') ?? 'en';
    _textSizeFactor = prefs.getDouble('textSizeFactor') ?? 1.0;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_languageNames.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);
      notifyListeners();
    }
  }

  Future<void> changeTextSize(double factor) async {
    _textSizeFactor = factor;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textSizeFactor', factor);
    notifyListeners();
  }

  Future<void> changeTextSizeByName(String sizeName) async {
    if (textSizePresets.containsKey(sizeName)) {
      _textSizeFactor = textSizePresets[sizeName]!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('textSizeFactor', _textSizeFactor);
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