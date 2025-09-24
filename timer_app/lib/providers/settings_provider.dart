import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _vibrationEnabled = true;
  bool _soundEnabled = true;
  String _selectedSound = 'alarm';
  bool _notificationsEnabled = true;

  bool get vibrationEnabled => _vibrationEnabled;
  bool get soundEnabled => _soundEnabled;
  String get selectedSound => _selectedSound;
  bool get notificationsEnabled => _notificationsEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _selectedSound = prefs.getString('selected_sound') ?? 'alarm';
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', enabled);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', enabled);
    notifyListeners();
  }

  Future<void> setSelectedSound(String sound) async {
    _selectedSound = sound;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_sound', sound);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    notifyListeners();
  }
}