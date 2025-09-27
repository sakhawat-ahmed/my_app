import 'lap_model.dart';

class StopwatchModel {
  Duration elapsed;
  bool isRunning;
  List<LapModel> laps;
  DateTime? startTime;
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

  // Serialization methods
  Map<String, dynamic> toJson() {
    return {
      'elapsed': elapsed.inMicroseconds,
      'isRunning': isRunning,
      'laps': laps.map((lap) => lap.toJson()).toList(),
      'startTime': startTime?.millisecondsSinceEpoch,
      'pausedDuration': pausedDuration?.inMicroseconds,
    };
  }

  factory StopwatchModel.fromJson(Map<String, dynamic> json) {
    return StopwatchModel(
      elapsed: Duration(microseconds: json['elapsed']),
      isRunning: json['isRunning'],
      laps: (json['laps'] as List).map((lapJson) => LapModel.fromJson(lapJson)).toList(),
      startTime: json['startTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['startTime'])
          : null,
      pausedDuration: json['pausedDuration'] != null
          ? Duration(microseconds: json['pausedDuration'])
          : null,
    );
  }
}