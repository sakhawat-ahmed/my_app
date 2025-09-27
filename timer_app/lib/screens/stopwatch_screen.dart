import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/app_provider.dart';
import 'package:timer_app/widgets/stopwatch_display.dart';
import 'package:timer_app/widgets/lap_list.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: StopwatchDisplay(),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: LapList(),
          ),
        ],
      ),
    );
  }
}