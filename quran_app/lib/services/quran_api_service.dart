import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranApiService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';
  
  // Edition codes for different languages
  static const Map<String, String> translationEditions = {
    'bn': 'bn.bengali', 
    'en': 'en.english', 
    'ar': 'ar.original', 
    'ur': 'ur.urdu',     
  };

  // Get all Surahs
  static Future<Map<String, dynamic>> getSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/surah'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  // Get specific Surah by number with translation
  static Future<Map<String, dynamic>> getSurah(int surahNumber, {String language = 'bn'}) async {
    final edition = translationEditions[language] ?? 'bn.bengali';
    final response = await http.get(Uri.parse('$baseUrl/surah/$surahNumber/$edition'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load surah $surahNumber');
    }
  }

  // Get verse with multiple translations
  static Future<Map<String, dynamic>> getVerse(int surahNumber, int verseNumber, {List<String> languages = const ['bn']}) async {
    final editionParams = languages.map((lang) => translationEditions[lang] ?? 'bn.bengali').join(',');
    final response = await http.get(Uri.parse('$baseUrl/ayah/$surahNumber:$verseNumber/editions/$editionParams'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load verse');
    }
  }
}