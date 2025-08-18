import 'dart:convert';

import 'package:quran_bengali_app/models/surah_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_bengali_app/models/ayah_model.dart';

class BookmarkService {
  static const String _bookmarkKey = 'bookmarked_ayahs';

  static Future<void> bookmarkAyah(Ayah ayah) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.add(ayah);
    await prefs.setString(_bookmarkKey, _encodeBookmarks(bookmarks));
  }

  static Future<void> bookmarkSurah(Surah surah) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    for (var ayah in surah.ayahs) {
      bookmarks.add(ayah);
    }
    await prefs.setString(_bookmarkKey, _encodeBookmarks(bookmarks));
  }

  static Future<void> removeBookmark(int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((ayah) => ayah.number == ayahNumber);
    await prefs.setString(_bookmarkKey, _encodeBookmarks(bookmarks));
  }

  static Future<List<Ayah>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookmarksString = prefs.getString(_bookmarkKey);
    if (bookmarksString == null || bookmarksString.isEmpty) {
      return [];
    }
    return _decodeBookmarks(bookmarksString);
  }

  static String _encodeBookmarks(List<Ayah> bookmarks) {
    return json.encode(bookmarks.map((ayah) => ayah.toJson()).toList());
  }

  static List<Ayah> _decodeBookmarks(String bookmarksString) {
    final List<dynamic> jsonList = json.decode(bookmarksString);
    return jsonList.map((json) => Ayah.fromJson(json)).toList();
  }
}