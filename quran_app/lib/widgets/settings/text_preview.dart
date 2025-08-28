import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/theme_provider.dart';

class TextPreview extends StatelessWidget {
  final ThemeProvider themeProvider;

  const TextPreview({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Text Size Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ',
              style: TextStyle(
                fontSize: 20 * themeProvider.textSizeFactor,
                fontWeight: FontWeight.bold,
                fontFamily: "Amiri",
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            Text(
              'আল্লাহর নামে শুরু করছি যিনি পরম করুণাময়, অতি দয়ালু।',
              style: TextStyle(
                fontSize: 16 * themeProvider.textSizeFactor,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}