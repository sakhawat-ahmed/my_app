import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/app_provider.dart';
import 'package:timer_app/screens/timer_screen.dart';
import 'package:timer_app/screens/stopwatch_screen.dart';
import 'package:timer_app/screens/settings_screen.dart';
import 'package:timer_app/widgets/custom_time_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.timer), text: 'Timers'),
            Tab(icon: Icon(Icons.watch_later), text: 'Stopwatch'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TimerScreen(),
          StopwatchScreen(),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    if (_tabController.index == 0) {
      return FloatingActionButton(
        onPressed: _showAddTimerDialog,
        child: const Icon(Icons.add),
      );
    }
    return const SizedBox.shrink();
  }

  void _showAddTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomTimePicker(
        onTimeSelected: (duration) {
          if (duration.inSeconds > 0) {
            Provider.of<AppProvider>(context, listen: false).addTimer(duration);
          }
        },
      ),
    );
  }
}