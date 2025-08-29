import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Quran App'),
        backgroundColor: themeProvider.themeData.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quran with Bengali Meaning',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'A beautiful app to read Quran with Bengali translation. This app provides an intuitive interface for reading and understanding the holy Quran with accurate Bengali translations.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(
                'Complete Quran text with Bengali translation',
                style: TextStyle(
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(
                'Bookmark your favorite verses',
                style: TextStyle(
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(
                'Search functionality',
                style: TextStyle(
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(
                'Customizable reading experience',
                style: TextStyle(
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}