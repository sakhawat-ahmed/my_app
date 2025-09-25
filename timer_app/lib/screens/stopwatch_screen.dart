import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/stopwatch_provider.dart';
import 'package:timer_app/widgets/stopwatch_widget.dart';
import 'package:timer_app/widgets/lap_list.dart';

class StopwatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: StopwatchWidget(),
          ),
          Expanded(
            flex: 3,
            child: LapList(),
          ),
        ],
      ),
    );
  }
}