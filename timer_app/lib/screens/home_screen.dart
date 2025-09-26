import 'package:flutter/material.dart' hide TimePickerDialog;
import 'package:provider/provider.dart';
import 'package:timer_app/providers/timer_provider.dart';
import 'package:timer_app/providers/stopwatch_provider.dart';
import 'package:timer_app/screens/timer_screen.dart';
import 'package:timer_app/screens/stopwatch_screen.dart';
import 'package:timer_app/screens/settings_screen.dart';
import 'package:timer_app/widgets/timer_widget.dart';
import 'package:timer_app/widgets/time_picker.dart';

class HomeScreen extends StatefulWidget {
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
        title: Text('Timer App'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Timers'),
            Tab(text: 'Stopwatch'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TimerScreen(),
          StopwatchScreen(),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        if (_tabController.index == 0) {
          return FloatingActionButton(
            onPressed: () {
              _showAddTimerDialog(context);
            },
            child: Icon(Icons.add),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  void _showAddTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TimePickerDialog(
        onTimeSelected: (duration) {
          if (duration.inSeconds > 0) {
            Provider.of<TimerProvider>(context, listen: false).addTimer(duration);
          }
        },
      ),
    );
  }
}