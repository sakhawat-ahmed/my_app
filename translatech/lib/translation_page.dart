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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Model: ${TranslationService.getModelStatus()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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
                    const Text(
                      'Original Text',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      minLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Enter text to translate...',
                        border: OutlineInputBorder(),
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
              child: ElevatedButton(
                onPressed: _isTranslating ? null : _translateText,
                child: _isTranslating 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Translate'),
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
                      const Text(
                        'Translation',
                        style: TextStyle(fontWeight: FontWeight.bold),
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

  Color _getStatusColor() {
    final status = TranslationService.getModelStatus();
    switch (status) {
      case 'Loaded':
        return Colors.green;
      case 'Loading':
        return Colors.orange;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLanguageDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)));
    }

    if (_translatedText.isEmpty) {
      return const Center(child: Text('Translation will appear here'));
    }

    return SingleChildScrollView(child: Text(_translatedText));
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
      
      final tempText = _textController.text;
      _textController.text = _translatedText;
      _translatedText = tempText;
    });
  }

  Future<void> _translateText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter text to translate';
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
        _translatedText = translated ?? 'Translation failed';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Translation error: $e';
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