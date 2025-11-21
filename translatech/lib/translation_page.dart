import 'package:flutter/material.dart';
import 'translation_service.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';
  bool _isTranslating = false;
  String _errorMessage = '';

  String _sourceLanguage = 'English';
  String _targetLanguage = 'Spanish';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NLLB Translator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Language Selection Row
            Row(
              children: [
                Expanded(
                  child: _buildLanguageDropdown(
                    value: _sourceLanguage,
                    onChanged: (value) => setState(() => _sourceLanguage = value!),
                    hint: 'From',
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: _swapLanguages,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLanguageDropdown(
                    value: _targetLanguage,
                    onChanged: (value) => setState(() => _targetLanguage = value!),
                    hint: 'To',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Input Text Field
            Expanded(
              flex: 2,
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Input Text',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter text to translate...',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Translate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isTranslating ? null : _translateText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isTranslating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Translate', style: TextStyle(fontSize: 16)),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Output Text
            Expanded(
              flex: 2,
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Translation',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _isTranslating
                            ? const Center(child: CircularProgressIndicator())
                            : _errorMessage.isNotEmpty
                                ? Text(
                                    _errorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  )
                                : SingleChildScrollView(
                                    child: Text(
                                      _translatedText.isEmpty 
                                          ? 'Translation will appear here...'
                                          : _translatedText,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _translatedText.isEmpty 
                                            ? Colors.grey 
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: NLLBLanguages.languages.keys.map((String language) {
        return DropdownMenuItem<String>(
          value: language,
          child: Text(language),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
      
      // Also swap the text
      final tempText = _textController.text;
      _textController.text = _translatedText;
      _translatedText = tempText;
    });
  }

  Future<void> _translateText() async {
    if (_textController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some text to translate';
      });
      return;
    }

    setState(() {
      _isTranslating = true;
      _errorMessage = '';
      _translatedText = '';
    });

    try {
      final translated = await TranslationService.translateText(
        text: _textController.text,
        sourceLang: NLLBLanguages.languages[_sourceLanguage]!,
        targetLang: NLLBLanguages.languages[_targetLanguage]!,
      );

      setState(() {
        _translatedText = translated ?? 'Translation failed';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isTranslating = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}