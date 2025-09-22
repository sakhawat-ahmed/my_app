import 'package:hive/hive.dart';

part 'lap_model.g.dart';

@HiveType(typeId: 2)
class LapModel {
  @HiveField(0)
  final Duration duration;
  
  @HiveField(1)
  final int lapNumber;
  
  @HiveField(2)
  final DateTime timestamp;

  LapModel({
    required this.duration,
    required this.lapNumber,
    required this.timestamp,
  });

  String get formattedTime {
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