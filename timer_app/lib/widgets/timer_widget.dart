import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/models/timer_model.dart';
import 'package:timer_app/providers/timer_provider.dart';

class TimerWidget extends StatelessWidget {
  final TimerModel timer;

  const TimerWidget({Key? key, required this.timer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (timer.title != null) ...[
              Text(
                timer.title!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
            ],
            LinearProgressIndicator(
              value: timer.progress,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(timer.remainingDuration),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: timer.isFinished ? Colors.red : null,
                      ),
                ),
                Row(
                  children: [
                    if (timer.isRunning) ...[
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: () => timerProvider.pauseTimer(timer.id),
                      ),
                    ] else if (!timer.isFinished) ...[
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () => timerProvider.startTimer(timer.id),
                      ),
                    ],
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () => timerProvider.resetTimer(timer.id),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => timerProvider.deleteTimer(timer.id),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
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