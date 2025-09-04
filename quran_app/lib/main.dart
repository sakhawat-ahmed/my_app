import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/splash_screen.dart';
import 'package:quran_app/screen/home_screen.dart';
import 'package:quran_app/screen/about_screen.dart';
import 'package:quran_app/provider/theme_provider.dart';
import 'package:quran_app/provider/quran_provider.dart';
import 'package:quran_app/data/bookmark_manager.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  await BookmarkManager.loadBookmarks();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => QuranProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "Quran Bengali App",
            theme: themeProvider.themeData,
            darkTheme: themeProvider.themeData,
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