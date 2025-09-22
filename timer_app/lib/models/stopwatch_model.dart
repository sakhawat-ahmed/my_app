import 'package:hive/hive.dart';
import 'lap_model.dart';

part 'stopwatch_model.g.dart';

@HiveType(typeId: 1)
class StopwatchModel {
  @HiveField(0)
  Duration elapsed;
  
  @HiveField(1)
  bool isRunning;
  
  @HiveField(2)
  List<LapModel> laps;
  
  @HiveField(3)
  DateTime? startTime;
  
  @HiveField(4)
  Duration? pausedDuration;

  StopwatchModel({
    this.elapsed = Duration.zero,
    this.isRunning = false,
    List<LapModel>? laps,
    this.startTime,
    this.pausedDuration,
  }) : laps = laps ?? [];

  void addLap() {
    laps.insert(0, LapModel(
      duration: elapsed,
      lapNumber: laps.length + 1,
      timestamp: DateTime.now(),
    ));
  }

  void reset() {
    elapsed = Duration.zero;
    isRunning = false;
    laps.clear();
    startTime = null;
    pausedDuration = null;
  }
}