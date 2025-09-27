import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/app_provider.dart';
import 'package:timer_app/widgets/timer_card.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final timers = appProvider.timers;

    return Scaffold(
      body: timers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No timers yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to create a timer',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: timers.length,
              itemBuilder: (context, index) {
                final timer = timers[index];
                return TimerCard(timer: timer);
              },
            ),
    );
  }
}