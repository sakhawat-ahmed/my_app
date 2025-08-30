import 'package:flutter/material.dart';

class SuraScreen extends StatelessWidget {
  final String arabic;
  final String bangla;
  final String title;

  const SuraScreen({
    super.key,
    required this.arabic,
    required this.bangla,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: "Amiri")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              arabic,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: "Amiri",
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              bangla,
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
