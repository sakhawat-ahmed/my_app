import 'package:hive/hive.dart';

part 'timer_model.g.dart';

@HiveType(typeId: 0)
class TimerModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final Duration initialDuration;
  
  @HiveField(2)
  Duration remainingDuration;
  
  @HiveField(3)
  bool isRunning;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  String? title;

  TimerModel({
    required this.id,
    required this.initialDuration,
    required this.remainingDuration,
    this.isRunning = false,
    required this.createdAt,
    this.title,
  });

  TimerModel copyWith({
    Duration? remainingDuration,
    bool? isRunning,
    String? title,
  }) {
    return TimerModel(
      id: id,
      initialDuration: initialDuration,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      isRunning: isRunning ?? this.isRunning,
      createdAt: createdAt,
      title: title ?? this.title,
    );
  }

  double get progress {
    if (initialDuration.inSeconds == 0) return 0;
    return 1 - (remainingDuration.inSeconds / initialDuration.inSeconds);
  }

  bool get isFinished => remainingDuration.inSeconds <= 0;
}