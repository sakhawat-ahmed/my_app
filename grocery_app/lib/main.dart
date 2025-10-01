import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/splash_screen.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load theme preference
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
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..setTheme(isDarkMode),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Grocery App',
            theme: themeProvider.currentTheme,
            home: FutureBuilder(
              future: AuthService.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                } else {
                  if (snapshot.hasData && snapshot.data != null) {
                    return const HomeScreen();
                  } else {
                    return const LoginScreen();
                  }
                }
              },
            ),
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