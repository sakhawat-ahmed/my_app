import 'package:flutter/material.dart';
import 'package:quran_app/data/bookmark_manager.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Bookmark> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    await BookmarkManager.loadBookmarks();
    setState(() {
      _bookmarks = BookmarkManager.bookmarks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_bookmarks.isEmpty) {
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
      itemCount: _bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = _bookmarks[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${bookmark.surahNumber}'),
            ),
            title: Text("${bookmark.surahEnglishName} - Verse ${bookmark.verseIndex + 1}"),
            subtitle: Text(bookmark.surahName),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeBookmark(bookmark),
            ),
            onTap: () {
              // Handle bookmark tap
              _showBookmarkInfo(context, bookmark);
            },
          ),
        );
      },
    );
  }

  Future<void> _removeBookmark(Bookmark bookmark) async {
    await BookmarkManager.removeBookmark(bookmark.surahNumber, bookmark.verseIndex);
    await _loadBookmarks(); // Reload the bookmarks
  }

  void _showBookmarkInfo(BuildContext context, Bookmark bookmark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bookmark Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Surah: ${bookmark.surahEnglishName} (${bookmark.surahName})'),
            Text('Verse: ${bookmark.verseIndex + 1}'),
            Text('Added: ${bookmark.timestamp.toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}