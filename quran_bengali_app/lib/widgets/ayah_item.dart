import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quran_bengali_app/models/ayah_model.dart';
import 'package:quran_bengali_app/services/bookmark_service.dart';

class AyahItem extends StatefulWidget {
  final Ayah arabicAyah;
  final Ayah? bengaliAyah;
  final int surahNumber;

  const AyahItem({
    super.key,
    required this.arabicAyah,
    this.bengaliAyah,
    required this.surahNumber,
  });

  @override
  _AyahItemState createState() => _AyahItemState();
}

class _AyahItemState extends State<AyahItem> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  Future<void> _checkIfBookmarked() async {
    final bookmarks = await BookmarkService.getBookmarks();
    setState(() {
      isBookmarked = bookmarks.any((b) => 
        b.number == widget.arabicAyah.number && 
        b.surahNumber == widget.surahNumber);
    });
  }

  Future<void> _toggleBookmark() async {
    if (isBookmarked) {
      await BookmarkService.removeBookmark(widget.arabicAyah.number);
    } else {
      await BookmarkService.bookmarkAyah(widget.arabicAyah);
    }
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  Future<void> _playAudio() async {
    if (isPlaying) {
      await audioPlayer.stop();
    } else {
      await audioPlayer.play(UrlSource(
        'https://verses.quran.com/audio/ar.alafasy/${widget.surahNumber}/${widget.arabicAyah.numberInSurah}.mp3'));
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Text(
                widget.arabicAyah.numberInSurah.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.green : null,
                  ),
                  onPressed: _toggleBookmark,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _playAudio,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          widget.arabicAyah.text,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'QuranFont',
          ),
        ),
        SizedBox(height: 16),
        if (widget.bengaliAyah != null)
          Text(
            widget.bengaliAyah!.text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        Divider(height: 32),
      ],
    );
  }
}