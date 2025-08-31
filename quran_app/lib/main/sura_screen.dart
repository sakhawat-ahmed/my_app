import 'package:flutter/material.dart';
import 'package:quran_app/data/sura_data.dart';
import 'package:quran_app/data/bookmark_manager.dart';

class SuraScreen extends StatefulWidget {
  final Surah surah;

  const SuraScreen({super.key, required this.surah});

  @override
  State<SuraScreen> createState() => _SuraScreenState();
}

class _SuraScreenState extends State<SuraScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.name, style: const TextStyle(fontFamily: "Amiri")),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.surah.arabicVerses.length,
        itemBuilder: (context, index) {
          final isBookmarked =
              BookmarkManager.isBookmarked(widget.surah, index);

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verse number + bookmark button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: isBookmarked ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isBookmarked) {
                              BookmarkManager.removeBookmark(
                                  widget.surah, index);
                            } else {
                              BookmarkManager.addBookmark(
                                  widget.surah, index);
                            }
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isBookmarked
                                    ? "Removed from bookmarks"
                                    : "Added to bookmarks",
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Arabic
                  Text(
                    widget.surah.arabicVerses[index],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Amiri",
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bangla Translation
                  Text(
                    widget.surah.banglaTranslation[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
