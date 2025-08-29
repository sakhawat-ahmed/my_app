import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/splash_screen.dart';
import 'package:quran_app/screen/home_screen.dart';
import 'package:quran_app/screen/about_screen.dart';
import 'provider/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "Quran Bengali App",
            theme: themeProvider.themeData,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
            routes: {
              '/home': (context) => const HomePage(),
              '/about': (context) => const AboutScreen(),
            },
          );
        },
      ),
    );
  }
}