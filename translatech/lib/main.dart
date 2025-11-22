import 'package:flutter/material.dart';
import 'translation_service.dart';
import 'translation_page.dart';

void main() {
  // Start preloading the model immediately when app starts
  TranslationService.preloadModel();
  runApp(const TranslationApp());
}

class TranslationApp extends StatelessWidget {
  const TranslationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NLLB Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TranslationPage(),
    );
  }
}