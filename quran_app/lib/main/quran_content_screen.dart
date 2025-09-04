import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_provider.dart';
import 'package:quran_app/main/sura_screen.dart';

class QuranContentScreen extends StatefulWidget {
  final QuranProvider quranProvider;
  final bool isLoading;

  const QuranContentScreen({
    super.key,
    required this.quranProvider,
    required this.isLoading,
  });

  @override
  State<QuranContentScreen> createState() => _QuranContentScreenState();
}

class _QuranContentScreenState extends State<QuranContentScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.quranProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${widget.quranProvider.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Reload data
                Provider.of<QuranProvider>(context, listen: false).loadSurahs();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.quranProvider.surahs.length,
      itemBuilder: (context, index) {
        final surah = widget.quranProvider.surahs[index];
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
              // Navigate to surah detail screen
              _navigateToSurahDetail(surah['number']);
            },
          ),
        );
      },
    );
  }

  void _navigateToSurahDetail(int surahNumber) async {
    try {
      // Show loading dialog
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

      // Load surah details
      final surahData = await widget.quranProvider.getSurah(surahNumber);
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Navigate to detail screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuraScreen(surahData: surahData),
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load surah: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
