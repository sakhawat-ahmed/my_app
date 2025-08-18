import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/surah_model.dart';

class QuranData {
  static Future<List<Surah>> loadSurahs() async {
    final String response = await rootBundle.loadString('assets/quran/quran_ar.json');
    final data = await json.decode(response);
    return List<Surah>.from(data.map((x) => Surah.fromJson(x)));
  }

  static Future<List<Surah>> loadBengaliTranslation() async {
    final String response = await rootBundle.loadString('assets/quran/quran_bn.json');
    final data = await json.decode(response);
    return List<Surah>.from(data.map((x) => Surah.fromJson(x)));
  }

  static Future<Map<int, String>> getSurahNames() async {
    final surahs = await loadSurahs();
    return {for (var surah in surahs) surah.number: surah.englishName};
  }
}