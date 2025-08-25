import 'package:flutter/material.dart';

class QuranContentScreen extends StatelessWidget {
  const QuranContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Amiri", 
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 8),
                Text(
                  "আল্লাহর নামে শুরু করছি যিনি পরম করুণাময়, অতি দয়ালু।",
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 8),
                Text(
                  "সমস্ত প্রশংসা আল্লাহর যিনি সমগ্র বিশ্বের প্রতিপালক।",
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}