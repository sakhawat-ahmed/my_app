import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/menu/menu_drawer.dart';
import 'package:quran_app/main/quran_content_screen.dart';
import 'package:quran_app/screen/bookmarks_screen.dart';
import 'package:quran_app/screen/settings_screen.dart';
import 'package:quran_app/provider/quran_provider.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  final List<Widget> _screens = [
    const QuranContentScreen(),
    const BookmarksScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load surahs when the screen initializes
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    await quranProvider.loadSurahs();
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);

    // Update the QuranContentScreen to pass the provider
    final List<Widget> updatedScreens = [
      QuranContentScreen(quranProvider: quranProvider, isLoading: _isLoading),
      const BookmarksScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("📖 Quran with Bangla Meaning"),
        centerTitle: true,
      ),
      drawer: MenuDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: updatedScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}