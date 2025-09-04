import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/splash_screen.dart';
import 'package:quran_app/screen/home_screen.dart';
import 'package:quran_app/screen/about_screen.dart';
import 'provider/theme_provider.dart';
import 'provider/quran_provider.dart'; // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Change from ChangeNotifierProvider to MultiProvider
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => QuranProvider()), // Add QuranProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "Quran Bengali App",
            theme: themeProvider.themeData,
            locale: Locale(themeProvider.currentLanguage),
            supportedLocales: const [
              Locale('bn', ''),
              Locale('en', ''),
              Locale('ar', ''),
              Locale('ur', ''),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
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