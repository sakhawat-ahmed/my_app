import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuranProvider with ChangeNotifier {
  List<dynamic> _surahs = [];
  List<dynamic> get surahs => _surahs;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _currentLanguage = 'bn';
  String get currentLanguage => _currentLanguage;

  final Map<String, String> translationEditions = {
    'bn': 'bn.bengali',
    'en': 'en.english', 
    'ar': 'ar.original',
    'ur': 'ur.urdu',
  };

  QuranProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadSurahs();
  }

  Future<void> loadSurahs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _surahs = data['data'];
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Failed to load data: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // NEW: Get surah with both Arabic and translation
  Future<Map<String, dynamic>> getSurahWithArabic(int surahNumber, {String? language}) async {
    try {
      final lang = language ?? _currentLanguage;
      final edition = translationEditions[lang] ?? 'bn.bengali';
      
      // Get Arabic text
      final arabicResponse = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/ar.original')
      );
      
      // Get translation
      final translationResponse = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/$edition')
      );
      
      if (arabicResponse.statusCode == 200 && translationResponse.statusCode == 200) {
        final arabicData = json.decode(arabicResponse.body);
        final translationData = json.decode(translationResponse.body);
        
        // Combine Arabic text with translation
        final combinedData = _combineArabicWithTranslation(arabicData, translationData);
        return combinedData;
      } else {
        throw Exception('Failed to load surah data');
      }
    } catch (e) {
      throw Exception('Failed to load surah: $e');
    }
  }

  // Helper method to combine Arabic text with translation
  Map<String, dynamic> _combineArabicWithTranslation(
    Map<String, dynamic> arabicData, 
    Map<String, dynamic> translationData
  ) {
    final arabicSurah = arabicData['data'];
    final translationSurah = translationData['data'];
    
    final combinedAyahs = [];
    
    for (int i = 0; i < arabicSurah['ayahs'].length; i++) {
      final arabicAyah = arabicSurah['ayahs'][i];
      final translationAyah = translationSurah['ayahs'][i];
      
      combinedAyahs.add({
        'number': arabicAyah['number'],
        'numberInSurah': arabicAyah['numberInSurah'],
        'arabicText': arabicAyah['text'],
        'translationText': translationAyah['text'],
        'juz': arabicAyah['juz'],
        'page': arabicAyah['page'],
      });
    }
    
    return {
      'data': {
        'number': arabicSurah['number'],
        'name': arabicSurah['name'],
        'englishName': arabicSurah['englishName'],
        'englishNameTranslation': arabicSurah['englishNameTranslation'],
        'numberOfAyahs': arabicSurah['numberOfAyahs'],
        'revelationType': arabicSurah['revelationType'],
        'ayahs': combinedAyahs,
      }
    };
  }

  Future<void> changeLanguage(String languageCode) async {
    if (translationEditions.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      notifyListeners();
    }
  }

  List<String> get availableLanguages => translationEditions.keys.toList();
}