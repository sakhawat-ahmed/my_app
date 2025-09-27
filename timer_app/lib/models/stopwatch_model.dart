import 'dart:convert';
import 'dart:async';
import 'lap_model.dart';

class StopwatchModel {
  Duration elapsed = Duration.zero;
  bool isRunning = false;
  List<LapModel> laps = [];
  DateTime startTime = DateTime.now();
  Duration pausedDuration = Duration.zero;
  Timer? ticker;

  StopwatchModel();

  void start() {
    if (!isRunning) {
      isRunning = true;
      startTime = DateTime.now();
    }
  }

  void pause() {
    if (isRunning) {
      isRunning = false;
      pausedDuration = elapsed;
      ticker?.cancel();
    }
  }

  void reset() {
    isRunning = false;
    elapsed = Duration.zero;
    pausedDuration = Duration.zero;
    laps.clear();
    ticker?.cancel();
  }

  void addLap() {
    if (isRunning) {
      laps.insert(0, LapModel(
        duration: elapsed,
        lapNumber: laps.length + 1,
        timestamp: DateTime.now(),
      ));
    }
  }

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'elapsed': elapsed.inMilliseconds,
      'isRunning': isRunning,
      'laps': laps.map((lap) => lap.toJson()).toList(),
      'startTime': startTime.millisecondsSinceEpoch,
      'pausedDuration': pausedDuration.inMilliseconds,
    };
  }

  factory StopwatchModel.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    final stopwatch = StopwatchModel();
    stopwatch.elapsed = Duration(milliseconds: json['elapsed']);
    stopwatch.isRunning = json['isRunning'];
    stopwatch.laps = (json['laps'] as List).map((lapJson) => LapModel.fromJson(lapJson)).toList();
    stopwatch.startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime']);
    stopwatch.pausedDuration = Duration(milliseconds: json['pausedDuration']);
    return stopwatch;
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}