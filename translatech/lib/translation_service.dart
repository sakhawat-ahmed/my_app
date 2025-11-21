import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TranslationService {
  static const String _baseUrl = 'https://api-inference.huggingface.co/models/facebook/nllb-200-3.3B';
  
  static Future<String?> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final String? apiKey = dotenv.env['HUGGING_FACE_API_KEY'];
    
    if (apiKey == null) {
      throw Exception('Hugging Face API key not found');
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'inputs': text,
          'parameters': {
            'src_lang': sourceLang,
            'tgt_lang': targetLang,
          }
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['translation_text'] != null) {
          return data[0]['translation_text'];
        }
      } else if (response.statusCode == 503) {
        // Model is loading, wait and retry
        await Future.delayed(const Duration(seconds: 10));
        return translateText(
          text: text,
          sourceLang: sourceLang,
          targetLang: targetLang,
        );
      } else {
        throw Exception('Translation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Translation error: $e');
    }
    
    return null;
  }
}

// NLLB-200 language codes
class NLLBLanguages {
  static const Map<String, String> languages = {
    'English': 'eng_Latn',
    'Spanish': 'spa_Latn',
    'French': 'fra_Latn',
    'German': 'deu_Latn',
    'Chinese': 'zho_Hans',
    'Japanese': 'jpn_Jpan',
    'Korean': 'kor_Hang',
    'Arabic': 'arb_Arab',
    'Hindi': 'hin_Deva',
    'Russian': 'rus_Cyrl',
    'Portuguese': 'por_Latn',
    'Italian': 'ita_Latn',
    'Dutch': 'nld_Latn',
    'Turkish': 'tur_Latn',
    'Vietnamese': 'vie_Latn',
    'Thai': 'tha_Thai',
    'Indonesian': 'ind_Latn',
    'Polish': 'pol_Latn',
    'Ukrainian': 'ukr_Cyrl',
  };
}