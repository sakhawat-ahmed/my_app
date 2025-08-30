import 'package:flutter/material.dart';
import 'package:quran_app/data/sura_data.dart';

class SuraScreen extends StatelessWidget {
  final Surah surah;

  const SuraScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(surah.name, style: const TextStyle(fontFamily: "Amiri")),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: surah.arabicVerses.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic
                  Text(
                    surah.arabicVerses[index],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Amiri",
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bangla Translation
                  Text(
                    surah.banglaTranslation[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
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
}
