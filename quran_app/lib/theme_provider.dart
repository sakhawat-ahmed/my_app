import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
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