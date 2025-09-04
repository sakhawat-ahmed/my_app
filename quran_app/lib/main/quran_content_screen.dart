import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_provider.dart';
import 'package:quran_app/main/sura_screen.dart';

class QuranContentScreen extends StatelessWidget {
  const QuranContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);
    
    if (quranProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (quranProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${quranProvider.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                quranProvider.loadSurahs();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: quranProvider.surahs.length,
      itemBuilder: (context, index) {
        final surah = quranProvider.surahs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                '${surah['number']}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              surah['englishName'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${surah['name']} • ${surah['englishNameTranslation']}',
            ),
            trailing: Text(
              '${surah['numberOfAyahs']} verses',
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              _navigateToSurahDetail(context, surah['number']);
            },
          ),
        );
      },
    );
  }

  void _navigateToSurahDetail(BuildContext context, int surahNumber) async {
  final quranProvider = Provider.of<QuranProvider>(context, listen: false);
  
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading surah...'),
          ],
        ),
      ),
    );

    // Use the new method that gets both Arabic and translation
    final surahData = await quranProvider.getSurahWithArabic(surahNumber);
    Navigator.pop(context);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuraScreen(surahData: surahData),
      ),
    );
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to load surah: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}