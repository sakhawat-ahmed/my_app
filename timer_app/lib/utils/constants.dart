import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );
}

class AppConstants {
  static const String appName = 'Timer App';
  static const String timerFinished = 'Timer Finished';
  static const String timerCompleted = 'Your timer has completed!';
  static const String defaultSound = 'alarm';
  static const Duration notificationDuration = Duration(seconds: 5);
}

class StorageKeys {
  static const String timers = 'timers';
  static const String stopwatch = 'stopwatch';
  static const String settings = 'settings';
  static const String theme = 'theme';
}