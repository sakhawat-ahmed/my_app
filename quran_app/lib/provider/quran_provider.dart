import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuranProvider with ChangeNotifier {
  List<dynamic> _surahs = [];
  List<dynamic> get surahs => _surahs;

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

  // Get specific surah
  Future<Map<String, dynamic>> getSurah(int surahNumber) async {
    try {
      final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load surah: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load surah: $e');
    }
  }

  // Search in Quran
  Future<Map<String, dynamic>> searchQuran(String query) async {
    try {
      final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/search/$query/all/en'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }
}