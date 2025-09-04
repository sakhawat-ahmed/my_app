import 'package:flutter/material.dart';
import 'package:quran_app/data/bookmark_manager.dart';

class SuraScreen extends StatefulWidget {
  final Map<String, dynamic> surahData;
  final int? initialVerseIndex;

  const SuraScreen({super.key, required this.surahData, this.initialVerseIndex});

  @override
  State<SuraScreen> createState() => _SuraScreenState();
}

class _SuraScreenState extends State<SuraScreen> {
  late ScrollController _scrollController;
  late Map<String, dynamic> surah;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    surah = widget.surahData['data'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialVerseIndex != null) {
        final position = widget.initialVerseIndex! * 200.0; // Increased for more space
        _scrollController.jumpTo(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verses = surah['ayahs'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${surah['englishName']} (${surah['name']})',
          style: const TextStyle(fontFamily: "Amiri"),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: verses.length,
        itemBuilder: (context, index) {
          final verse = verses[index];
          final isHighlighted = widget.initialVerseIndex == index;

          return Card(
            elevation: 2,
            color: isHighlighted ? Colors.yellow[100] : null,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verse number
                  Text(
                    "আয়াত ${verse['numberInSurah']}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Arabic text (Original)
                  Text(
                    verse['arabicText'],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Amiri",
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  const Divider(),
                  const SizedBox(height: 8),

                  // Bangla Translation
                  Text(
                    verse['translationText'],
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}