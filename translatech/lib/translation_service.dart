import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _baseUrl = 'https://api-inference.huggingface.co/models/facebook/nllb-200-3.3B';
  static bool _isModelLoaded = false;
  static bool _isLoading = false;

  /// Preload the model to avoid timeouts on first translation
  static Future<void> preloadModel() async {
    if (_isModelLoaded || _isLoading) return;
    
    _isLoading = true;
    
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'inputs': 'hello',
          'parameters': {
            'src_lang': 'eng_Latn',
            'tgt_lang': 'spa_Latn'
          }
        }),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200 || response.statusCode == 503) {
        _isModelLoaded = true;
        await Future.delayed(const Duration(seconds: 10));
      }
    } catch (e) {
      // Preload failed, but continue anyway
    } finally {
      _isLoading = false;
    }
  }

  /// Check if model is ready and load if needed
  static Future<bool> ensureModelReady() async {
    if (_isModelLoaded) return true;
    
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _isModelLoaded = true;
        return true;
      }
    } catch (e) {
      // Check failed
    }
    
    await preloadModel();
    return _isModelLoaded;
  }

  /// Main translation function
  static Future<String?> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    try {
      await ensureModelReady();
      
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
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['translation_text'] != null) {
          return data[0]['translation_text'];
        }
      } else if (response.statusCode == 503) {
        await Future.delayed(const Duration(seconds: 15));
        return await _retryTranslation(text, sourceLang, targetLang);
      }
    } catch (e) {
      return await _retryTranslation(text, sourceLang, targetLang);
    }
    
    return null;
  }

  /// Retry translation with longer timeout
  static Future<String?> _retryTranslation(
    String text, String sourceLang, String targetLang,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'inputs': text,
          'parameters': {
            'src_lang': sourceLang,
            'tgt_lang': targetLang,
          }
        }),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['translation_text'] != null) {
          _isModelLoaded = true;
          return data[0]['translation_text'];
        }
      }
    } catch (e) {
      // Retry failed
    }
    
    return 'Translation failed';
  }

  /// Get model status for UI
  static String getModelStatus() {
    if (_isLoading) return 'Loading';
    return _isModelLoaded ? 'Loaded' : 'Failed';
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