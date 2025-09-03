import 'package:flutter/foundation.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:quran_app/services/quran_api_service.dart';

class QuranProvider with ChangeNotifier {
  List<Surah> _surahs = [];
  List<Surah> get surahs => _surahs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Load all surahs
  Future<void> loadSurahs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await QuranApiService.getSurahs();
      final List<dynamic> data = response['data'];
      
      _surahs = data.map((json) => Surah.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get specific surah with optional translation
  Future<Map<String, dynamic>> getSurah(int surahNumber, {String? translation}) async {
    try {
      final response = await QuranApiService.getSurah(surahNumber, translationLanguage: translation);
      return response;
    } catch (e) {
      throw Exception('Failed to load surah: $e');
    }
  }

  // Search in Quran
  Future<Map<String, dynamic>> searchQuran(String query, {String? language}) async {
    try {
      final response = await QuranApiService.searchQuran(query, language: language);
      return response;
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }
}