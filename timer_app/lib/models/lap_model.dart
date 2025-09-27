
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
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final milliseconds = duration.inMilliseconds.remainder(1000);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0').substring(0, 2)}';
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration.inMilliseconds,
      'lapNumber': lapNumber,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory LapModel.fromJson(Map<String, dynamic> json) {
    return LapModel(
      duration: Duration(milliseconds: json['duration']),
      lapNumber: json['lapNumber'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}