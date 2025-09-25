import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/stopwatch_provider.dart';

class LapList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    final laps = stopwatchProvider.stopwatch.laps;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Laps (${laps.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: laps.isEmpty
              ? Center(
                  child: Text(
                    'No laps recorded',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    final lap = laps[index];
                    return ListTile(
                      leading: Text('Lap ${lap.lapNumber}'),
                      trailing: Text(lap.formattedTime),
                    );
                  },
                ),
        ),
      ],
    );
  }
}