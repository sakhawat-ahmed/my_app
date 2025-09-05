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

  Future<Map<String, dynamic>> getSurah(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber')
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load surah: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load surah: $e');
    }
  }

  Future<Map<String, dynamic>> getSurahWithTranslation(int surahNumber, {String? language}) async {
    try {
      final lang = language ?? _currentLanguage;
      final edition = translationEditions[lang] ?? 'bn.bengali';
      
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/$edition')
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load surah: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load surah: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (translationEditions.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      notifyListeners();
    }
  }

  List<String> get availableLanguages => translationEditions.keys.toList();
}