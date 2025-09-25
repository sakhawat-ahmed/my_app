import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/timer_provider.dart';
import 'package:timer_app/widgets/timer_widget.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      body: timerProvider.timers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No timers yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to create a new timer',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: timerProvider.timers.length,
              itemBuilder: (context, index) {
                final timer = timerProvider.timers[index];
                return TimerWidget(timer: timer);
              },
            ),
    );
  }
}