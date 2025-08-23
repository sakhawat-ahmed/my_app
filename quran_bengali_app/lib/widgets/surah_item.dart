import 'package:flutter/material.dart';
import 'package:quran_bengali_app/models/surah_model.dart';

class SurahItem extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahItem({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                surah.number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.englishName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    surah.englishNameTranslation,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              surah.name,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'QuranFont',
              ),
            ),
          ],
        ),
      ),
    );
  }
}