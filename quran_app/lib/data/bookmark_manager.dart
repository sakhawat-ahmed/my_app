import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 

class Bookmark {
  final int surahNumber;
  final int verseIndex;
  final String surahName;
  final String surahEnglishName;
  final DateTime timestamp;

  Bookmark({
    required this.surahNumber,
    required this.verseIndex,
    required this.surahName,
    required this.surahEnglishName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'surahNumber': surahNumber,
      'verseIndex': verseIndex,
      'surahName': surahName,
      'surahEnglishName': surahEnglishName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      surahNumber: map['surahNumber'],
      verseIndex: map['verseIndex'],
      surahName: map['surahName'],
      surahEnglishName: map['surahEnglishName'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class BookmarkManager {
  static List<Bookmark> _bookmarks = [];

  static List<Bookmark> get bookmarks => _bookmarks;

  static Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getStringList('bookmarks') ?? [];
    
    _bookmarks = bookmarksJson.map((jsonString) {
      final map = json.decode(jsonString); // Use json.decode here
      return Bookmark.fromMap(map);
    }).toList();
  }

  static Future<void> addBookmark({
    required int surahNumber,
    required int verseIndex,
    required String surahName,
    required String surahEnglishName,
  }) async {
    final bookmark = Bookmark(
      surahNumber: surahNumber,
      verseIndex: verseIndex,
      surahName: surahName,
      surahEnglishName: surahEnglishName,
      timestamp: DateTime.now(),
    );

    _bookmarks.add(bookmark);
    await _saveBookmarks();
  }

  static Future<void> removeBookmark(int surahNumber, int verseIndex) async {
    _bookmarks.removeWhere((bookmark) =>
      bookmark.surahNumber == surahNumber && bookmark.verseIndex == verseIndex);
    await _saveBookmarks();
  }

  static Future<bool> isBookmarked(int surahNumber, int verseIndex) async {
    return _bookmarks.any((bookmark) =>
      bookmark.surahNumber == surahNumber && bookmark.verseIndex == verseIndex);
  }

  static Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = _bookmarks.map((bookmark) => json.encode(bookmark.toMap())).toList();
    await prefs.setStringList('bookmarks', bookmarksJson);
  }

  static Future<void> clearAllBookmarks() async {
    _bookmarks.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bookmarks');
  }
}