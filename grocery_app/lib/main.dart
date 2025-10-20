import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/splash_screen.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/providers/favorites_provider.dart'; 
import 'package:provider/provider.dart';
import 'package:grocery_app/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final isDarkMode = await AuthService.getThemePreference();
  
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..setTheme(isDarkMode)),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()), 
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Grocery App',
            theme: themeProvider.currentTheme,
            home: const AppInitializer(),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<bool> _authCheckFuture;

  @override
  void initState() {
    super.initState();
    _authCheckFuture = _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    // Add a minimum splash screen duration for better UX
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final currentUser = await AuthService.getCurrentUser();
    return currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authCheckFuture,
      builder: (context, snapshot) {
        // Always show splash screen while checking auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // If we have the result, navigate to appropriate screen
        if (snapshot.hasData) {
          return snapshot.data! ? const HomeScreen() : const LoginScreen();
        }

        // If there's an error, fall back to login screen
        return const LoginScreen();
      },
    );
  }
}