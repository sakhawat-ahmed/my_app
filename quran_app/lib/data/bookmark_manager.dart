import 'sura_data.dart';

class BookmarkManager {
  static final List<Bookmark> _bookmarks = [];

  static List<Bookmark> get bookmarks => _bookmarks;

  static void addBookmark(Surah surah, int verseIndex) {
    _bookmarks.add(Bookmark(surah, verseIndex));
  }

  static void removeBookmark(Surah surah, int verseIndex) {
    _bookmarks.removeWhere(
        (b) => b.surah == surah && b.verseIndex == verseIndex);
  }

  static bool isBookmarked(Surah surah, int verseIndex) {
    return _bookmarks
        .any((b) => b.surah == surah && b.verseIndex == verseIndex);
  }
}

class Bookmark {
  final Surah surah;
  final int verseIndex;

  Bookmark(this.surah, this.verseIndex);
}
