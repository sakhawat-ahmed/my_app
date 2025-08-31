import 'package:flutter/material.dart';
import 'package:quran_app/data/bookmark_manager.dart';
import 'package:quran_app/main/sura_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarks = BookmarkManager.bookmarks;

    if (bookmarks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Your Bookmarks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'No bookmarks yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        final surah = bookmark.surah;
        final verseIndex = bookmark.verseIndex;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text("${surah.name} - Verse ${verseIndex + 1}"),
            subtitle: Text(
              surah.banglaTranslation[verseIndex],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
