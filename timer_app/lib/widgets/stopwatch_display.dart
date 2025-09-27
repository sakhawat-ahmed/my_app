import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/app_provider.dart';

class StopwatchDisplay extends StatelessWidget {
  const StopwatchDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final stopwatch = appProvider.stopwatch;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(stopwatch.elapsed),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildControlButtons(appProvider, stopwatch),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildControlButtons(AppProvider appProvider, dynamic stopwatch) {
    if (!stopwatch.isRunning) {
      return [
        ElevatedButton.icon(
          onPressed: appProvider.startStopwatch,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start'),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: appProvider.resetStopwatch,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
      ];
    }

    return [
      ElevatedButton.icon(
        onPressed: appProvider.pauseStopwatch,
        icon: const Icon(Icons.pause),
        label: const Text('Pause'),
      ),
      const SizedBox(width: 16),
      ElevatedButton.icon(
        onPressed: appProvider.addLap,
        icon: const Icon(Icons.flag),
        label: const Text('Lap'),
      ),
    ];
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final milliseconds = duration.inMilliseconds.remainder(1000);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0').substring(0, 2)}';
    }
  }
}