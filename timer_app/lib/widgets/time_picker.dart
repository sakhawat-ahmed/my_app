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
      title: Text('Set Timer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildTimePicker('Hours', 0, 23, _hours, (value) {
                setState(() => _hours = value);
              }),
              _buildTimePicker('Minutes', 0, 59, _minutes, (value) {
                setState(() => _minutes = value);
              }),
              _buildTimePicker('Seconds', 0, 59, _seconds, (value) {
                setState(() => _seconds = value);
              }),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final duration = Duration(
              hours: _hours,
              minutes: _minutes,
              seconds: _seconds,
            );
            widget.onTimeSelected(duration);
            Navigator.pop(context);
          },
          child: Text('Set Timer'),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, int min, int max, int value, Function(int) onChanged) {
    return Expanded(
      child: Column(
        children: [
          Text(label),
          SizedBox(height: 8),
          DropdownButton<int>(
            value: value,
            onChanged: (newValue) => onChanged(newValue!),
            items: List.generate(max - min + 1, (index) {
              final number = min + index;
              return DropdownMenuItem(
                value: number,
                child: Text(number.toString().padLeft(2, '0')),
              );
            }),
          ),
        ],
      ),
    );
  }
}