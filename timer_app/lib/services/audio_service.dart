import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  static Future<void> playSound(String soundName) async {
    try {
      if (_isPlaying) {
        await _player.stop();
      }
      
      await _player.play(AssetSource('sounds/$soundName.mp3'));
      _isPlaying = true;
      
      _player.onPlayerComplete.listen((event) {
        _isPlaying = false;
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> stopSound() async {
    await _player.stop();
    _isPlaying = false;
  }

  static Future<void> vibrate({int duration = 500}) async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: duration);
    }
  }
}