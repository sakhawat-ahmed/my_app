import 'package:flutter/material.dart';
import 'splash_screen.dart'; 

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quran Bengali App",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}