import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranApiService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  // Get all Surahs
  static Future<Map<String, dynamic>> getSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/surah'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  // Get specific Surah by number
  static Future<Map<String, dynamic>> getSurah(int surahNumber, {String? translationLanguage}) async {
    String url = '$baseUrl/surah/$surahNumber';
    if (translationLanguage != null) {
      url += '/$translationLanguage';
    }
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load surah $surahNumber');
    }
  }

  // Search Quran text
  static Future<Map<String, dynamic>> searchQuran(String query, {String? language}) async {
    String url = '$baseUrl/search/$query';
    if (language != null) {
      url += '/$language';
    }
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search Quran');
    }
  }

  // Get available translations
  static Future<Map<String, dynamic>> getAvailableTranslations() async {
    final response = await http.get(Uri.parse('$baseUrl/edition'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load translations');
    }
  }
}