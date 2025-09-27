import 'dart:convert';
import 'dart:async';

class TimerModel {
  final String id;
  final Duration initialDuration;
  Duration remainingDuration;
  bool isRunning;
  final DateTime createdAt;
  String? title;
  Timer? ticker;

  TimerModel({
    required this.id,
    required this.initialDuration,
    required this.remainingDuration,
    this.isRunning = false,
    required this.createdAt,
    this.title,
  });

  double get progress {
    if (initialDuration.inSeconds == 0) return 0;
    return 1 - (remainingDuration.inSeconds / initialDuration.inSeconds);
  }

  bool get isFinished => remainingDuration.inSeconds <= 0;

  void start() {
    isRunning = true;
  }

  void pause() {
    isRunning = false;
    ticker?.cancel();
  }

  void reset() {
    isRunning = false;
    remainingDuration = initialDuration;
    ticker?.cancel();
  }

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initialDuration': initialDuration.inSeconds,
      'remainingDuration': remainingDuration.inSeconds,
      'isRunning': isRunning,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'title': title,
    };
  }

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'],
      initialDuration: Duration(seconds: json['initialDuration']),
      remainingDuration: Duration(seconds: json['remainingDuration']),
      isRunning: json['isRunning'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      title: json['title'],
    );
  }

  static String listToJson(List<TimerModel> timers) {
    return json.encode(timers.map((timer) => timer.toJson()).toList());
  }

  static List<TimerModel> listFromJson(String jsonString) {
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => TimerModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}