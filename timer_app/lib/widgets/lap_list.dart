import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/providers/app_provider.dart';

class LapList extends StatelessWidget {
  const LapList({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final laps = appProvider.stopwatch.laps;

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Laps (${laps.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: laps.isEmpty
                ? Center(
                    child: Text(
                      'No laps recorded',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: laps.length,
                    itemBuilder: (context, index) {
                      final lap = laps[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${lap.lapNumber}'),
                        ),
                        title: Text('Lap ${lap.lapNumber}'),
                        trailing: Text(
                          lap.formattedTime,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontFamily: 'monospace',
                              ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}