import 'package:flutter/material.dart';
import 'package:quran_bengali_app/models/ayah_model.dart';
import 'package:quran_bengali_app/models/surah_model.dart';
import 'package:quran_bengali_app/services/bookmark_service.dart';
import 'package:quran_bengali_app/services/quran_data.dart';
import 'package:quran_bengali_app/widgets/ayah_item.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({Key? key, required this.surah}) : super(key: key);

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List<Ayah>? bengaliAyahs;
  bool isLoading = true;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBengaliTranslation();
    _checkIfBookmarked();
  }

  Future<void> _loadBengaliTranslation() async {
    final translations = await QuranData.loadBengaliTranslation();
    final surahTranslation = translations.firstWhere(
      (s) => s.number == widget.surah.number,
      orElse: () => widget.surah,
    );
    
    setState(() {
      bengaliAyahs = surahTranslation.ayahs;
      isLoading = false;
    });
  }

  Future<void> _checkIfBookmarked() async {
    final bookmarks = await BookmarkService.getBookmarks();
    setState(() {
      isBookmarked = bookmarks.any((b) => b.surahNumber == widget.surah.number);
    });
  }

  Future<void> _toggleBookmark() async {
    if (isBookmarked) {
      await BookmarkService.removeBookmark(widget.surah.number);
    } else {
      await BookmarkService.bookmarkSurah(widget.surah);
    }
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.englishName),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.surah.ayahs.length,
              itemBuilder: (context, index) {
                final arabicAyah = widget.surah.ayahs[index];
                final bengaliAyah = bengaliAyahs?[index];
                return AyahItem(
                  arabicAyah: arabicAyah,
                  bengaliAyah: bengaliAyah,
                  surahNumber: widget.surah.number,
                );
              },
            ),
    );
  }
}