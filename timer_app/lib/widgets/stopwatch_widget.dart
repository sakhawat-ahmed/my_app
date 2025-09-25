import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/stopwatch_provider.dart';

class StopwatchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    final elapsed = stopwatchProvider.stopwatch.elapsed;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDuration(elapsed),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!stopwatchProvider.stopwatch.isRunning) ...[
                ElevatedButton(
                  onPressed: stopwatchProvider.start,
                  child: Text('Start'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: stopwatchProvider.reset,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: stopwatchProvider.pause,
                  child: Text('Pause'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: stopwatchProvider.addLap,
                  child: Text('Lap'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
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