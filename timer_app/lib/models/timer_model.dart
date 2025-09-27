class TimerModel {
  final String id;
  final Duration initialDuration;
  Duration remainingDuration;
  bool isRunning;
  final DateTime createdAt;
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

  // Serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initialDuration': initialDuration.inMicroseconds,
      'remainingDuration': remainingDuration.inMicroseconds,
      'isRunning': isRunning,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'title': title,
    };
  }

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'],
      initialDuration: Duration(microseconds: json['initialDuration']),
      remainingDuration: Duration(microseconds: json['remainingDuration']),
      isRunning: json['isRunning'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      title: json['title'],
    );
  }
}