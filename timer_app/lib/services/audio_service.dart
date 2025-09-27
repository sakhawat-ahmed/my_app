import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playAlarmSound() async {
    try {
      await _player.play(AssetSource('sounds/alarm.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
      // Fallback: use system vibration if sound fails
      await vibrate();
    }
  }

  static Future<void> vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000);
    }
  }
}