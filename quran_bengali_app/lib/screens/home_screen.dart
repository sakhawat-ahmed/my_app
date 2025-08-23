import 'package:flutter/material.dart';
import 'package:quran_bengali_app/models/surah_model.dart';
import 'package:quran_bengali_app/screens/surah_detail_screen.dart';
import 'package:quran_bengali_app/services/quran_data.dart';
import 'package:quran_bengali_app/widgets/surah_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Surah>> futureSurahs;
  List<Surah> surahs = [];
  List<Surah> filteredSurahs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureSurahs = QuranData.loadSurahs();
    futureSurahs.then((value) {
      setState(() {
        surahs = value;
        filteredSurahs = value;
      });
    });
  }

  void filterSurahs(String query) {
    setState(() {
      filteredSurahs = surahs.where((surah) {
        final name = surah.englishName.toLowerCase();
        final translation = surah.englishNameTranslation.toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || translation.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran with Bengali Translation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SurahSearchDelegate(surahs: surahs),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Surah>>(
        future: futureSurahs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: filteredSurahs.length,
              itemBuilder: (context, index) {
                final surah = filteredSurahs[index];
                return SurahItem(
                  surah: surah,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailScreen(surah: surah),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class SurahSearchDelegate extends SearchDelegate {
  final List<Surah> surahs;

  SurahSearchDelegate({required this.surahs});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Surah> results = surahs.where((surah) {
      final name = surah.englishName.toLowerCase();
      final translation = surah.englishNameTranslation.toLowerCase();
      final searchLower = query.toLowerCase();
      return name.contains(searchLower) || translation.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final surah = results[index];
        return ListTile(
          title: Text(surah.englishName),
          subtitle: Text(surah.englishNameTranslation),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurahDetailScreen(surah: surah),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Surah> suggestions = surahs.where((surah) {
      final name = surah.englishName.toLowerCase();
      final translation = surah.englishNameTranslation.toLowerCase();
      final searchLower = query.toLowerCase();
      return name.contains(searchLower) || translation.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final surah = suggestions[index];
        return ListTile(
          title: Text(surah.englishName),
          subtitle: Text(surah.englishNameTranslation),
          onTap: () {
            query = surah.englishName;
            showResults(context);
          },
        );
      },
    );
  }
}