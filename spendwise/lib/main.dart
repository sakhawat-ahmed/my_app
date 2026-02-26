import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io' show Platform;
import 'config/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/firebase_provider.dart';
import 'services/hive_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool firebaseInitialized = false;
  
  if (!Platform.isLinux && !Platform.isWindows) {
    try {
      await Firebase.initializeApp();
      firebaseInitialized = true;
    } catch (e) {
      print('Firebase initialization failed: $e');
    }
  }
  
  await HiveService.init();
  
  // Cannot use const here because overrides are dynamic
  var firebaseAvailableProvider;
  runApp(
    ProviderScope(
      overrides: [
        firebaseAvailableProvider.overrideWithValue(firebaseInitialized),
      ],
      child: const MyApp(), // MyApp must have const constructor
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: authState.user != null 
          ? const HomeScreen() 
          : const LoginScreen(),
    );
  }
}