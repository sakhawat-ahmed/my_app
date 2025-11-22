import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _baseUrl = 'https://api-inference.huggingface.co/models/facebook/nllb-200-3.3B';
  
  static Future<String?> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    try {
      print('Translating: "$text" from $sourceLang to $targetLang');
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['translation_text'] != null) {
          return data[0]['translation_text'];
        }
      } else if (response.statusCode == 503) {
        // Model is loading
        print('Model loading, waiting 20 seconds...');
        await Future.delayed(const Duration(seconds: 20));
        return await translateText(
          text: text,
          sourceLang: sourceLang,
          targetLang: targetLang,
        );
      } else {
        // Try with a smaller model
        print('Trying with smaller model...');
        return await _fallbackTranslation(text, sourceLang, targetLang);
      }
    } catch (e) {
      print('Translation error: $e');
      return 'Error: $e';
    }
    
    return null;
  }

  static Future<String?> _fallbackTranslation(
    String text, String sourceLang, String targetLang
  ) async {
    // Try with a smaller, faster model
    try {
      final response = await http.post(
        Uri.parse('https://api-inference.huggingface.co/models/facebook/nllb-200-distilled-600M'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'inputs': text,
          'parameters': {'src_lang': sourceLang, 'tgt_lang': targetLang}
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['translation_text'] != null) {
          return data[0]['translation_text'];
        }
      }
    } catch (e) {
      print('Fallback translation error: $e');
    }
    
    return 'Translation service unavailable. Please try again.';
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