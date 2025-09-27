import 'package:flutter/material.dart';

class TimePickerDialog extends StatefulWidget {
  final Function(Duration) onTimeSelected;

  const TimePickerDialog({Key? key, required this.onTimeSelected}) : super(key: key);

  @override
  _TimePickerDialogState createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Timer Duration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit('Hours', _hours, 0, 23, (value) => _hours = value),
              _buildTimeUnit('Minutes', _minutes, 0, 59, (value) => _minutes = value),
              _buildTimeUnit('Seconds', _seconds, 0, 59, (value) => _seconds = value),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Total: ${_formatTotalDuration()}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _onConfirm,
          child: const Text('Set Timer'),
        ),
      ],
    );
  }

  Widget _buildTimeUnit(String label, int value, int min, int max, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: DropdownButtonFormField<int>(
            initialValue: value,
            items: List.generate(max - min + 1, (index) {
              final number = min + index;
              return DropdownMenuItem<int>(
                value: number,
                child: Text(number.toString().padLeft(2, '0')),
              );
            }),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  onChanged(newValue);
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTotalDuration() {
    final duration = Duration(hours: _hours, minutes: _minutes, seconds: _seconds);
    if (_hours > 0) {
      return '${_hours}h ${_minutes}m ${_seconds}s';
    } else if (_minutes > 0) {
      return '${_minutes}m ${_seconds}s';
    } else {
      return '${_seconds}s';
    }
  }

  void _onConfirm() {
    final duration = Duration(hours: _hours, minutes: _minutes, seconds: _seconds);
    if (duration.inSeconds > 0) {
      widget.onTimeSelected(duration);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a valid duration')),
      );
    }
  }
} 