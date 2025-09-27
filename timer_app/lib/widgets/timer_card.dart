import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/app_provider.dart';
import 'package:timer_app/models/timer_model.dart';

class TimerCard extends StatelessWidget {
  final TimerModel timer;

  const TimerCard({Key? key, required this.timer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (timer.title != null) ...[
              Text(
                timer.title!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
            ],
            LinearProgressIndicator(
              value: timer.progress,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(timer.remainingDuration),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: timer.isFinished ? Colors.red : null,
                        fontFamily: 'monospace',
                      ),
                ),
                Row(
                  children: _buildActionButtons(appProvider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(AppProvider appProvider) {
    if (timer.isFinished) {
      return [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => appProvider.resetTimer(timer.id),
          tooltip: 'Reset',
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => appProvider.deleteTimer(timer.id),
          tooltip: 'Delete',
        ),
      ];
    }

    if (timer.isRunning) {
      return [
        IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () => appProvider.pauseTimer(timer.id),
          tooltip: 'Pause',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => appProvider.resetTimer(timer.id),
          tooltip: 'Reset',
        ),
      ];
    }

    return [
      IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: () => appProvider.startTimer(timer.id),
        tooltip: 'Start',
      ),
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () => appProvider.resetTimer(timer.id),
        tooltip: 'Reset',
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => appProvider.deleteTimer(timer.id),
        tooltip: 'Delete',
      ),
    ];
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}