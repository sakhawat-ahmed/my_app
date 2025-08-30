import 'package:flutter/material.dart';
import 'sura_screen.dart';

class QuranContentScreen extends StatelessWidget {
  const QuranContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SuraScreen(
                  arabic: "بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                  bangla: "আল্লাহর নামে শুরু করছি যিনি পরম করুণাময়, অতি দয়ালু।",
                  title: "সূরা ফাতিহা - আয়াত 1",
                ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Amiri",
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "আল্লাহর নামে শুরু করছি যিনি পরম করুণাময়, অতি দয়ালু।",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SuraScreen(
                  arabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
                  bangla: "সমস্ত প্রশংসা আল্লাহর যিনি সমগ্র বিশ্বের প্রতিপালক।",
                  title: "সূরা ফাতিহা - আয়াত 2",
                ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "সমস্ত প্রশংসা আল্লাহর যিনি সমগ্র বিশ্বের প্রতিপালক।",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
