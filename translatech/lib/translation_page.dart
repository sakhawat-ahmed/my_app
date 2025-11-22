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
            // Language Selection
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
                  tooltip: 'Swap languages',
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
            
            // Input Section
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Text',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      minLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter text to translate...',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Translate Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isTranslating ? null : _translateText,
                icon: _isTranslating 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.translate),
                label: Text(_isTranslating ? 'Translating...' : 'Translate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Output Section
            Expanded(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Translation',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _buildOutputContent(),
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
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildOutputContent() {
    if (_isTranslating) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Translating... This may take a moment.'),
            SizedBox(height: 8),
            Text(
              'First translation might take longer as the model loads',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _translateText,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_translatedText.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.translate, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Translation will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Text(
        _translatedText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
      
      // Swap text content
      final tempText = _textController.text;
      _textController.text = _translatedText;
      _translatedText = tempText;
    });
  }

  Future<void> _translateText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
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
        text: text,
        sourceLang: NLLBLanguages.languages[_sourceLanguage]!,
        targetLang: NLLBLanguages.languages[_targetLanguage]!,
      );

      setState(() {
        _translatedText = translated ?? 'No translation received';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Translation failed: $e\n\nPlease check your internet connection and try again.';
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