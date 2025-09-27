class LapModel {
  final Duration duration;
  final int lapNumber;
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

  // Serialization methods
  Map<String, dynamic> toJson() {
    return {
      'duration': duration.inMicroseconds,
      'lapNumber': lapNumber,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory LapModel.fromJson(Map<String, dynamic> json) {
    return LapModel(
      duration: Duration(microseconds: json['duration']),
      lapNumber: json['lapNumber'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}