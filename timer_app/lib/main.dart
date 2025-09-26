import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/theme_provider.dart';
import 'package:timer_app/providers/timer_provider.dart';
import 'package:timer_app/providers/stopwatch_provider.dart';
import 'package:timer_app/providers/settings_provider.dart';
import 'package:timer_app/services/notification_service.dart';
import 'package:timer_app/services/storage_service.dart';
import 'package:timer_app/screens/home_screen.dart';
import 'package:timer_app/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await StorageService.init();
  await NotificationService.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => StopwatchProvider()),
      ],
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        
        return MaterialApp(
          title: 'Timer App',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },
    );
  }
}