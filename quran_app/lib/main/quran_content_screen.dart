import 'package:flutter/material.dart';
import 'sura_screen.dart';
import 'package:quran_app/data/sura_data.dart';

class QuranContentScreen extends StatelessWidget {
  const QuranContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: surahList.length,
      itemBuilder: (context, index) {
        final surah = surahList[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              surah.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SuraScreen(surah: surah),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
