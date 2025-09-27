import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_app/models/timer_model.dart';
import 'package:timer_app/models/stopwatch_model.dart';
import 'package:timer_app/services/notification_service.dart';
import 'package:timer_app/services/audio_service.dart';

class AppProvider with ChangeNotifier {
  ThemeData _currentTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
  );

  List<TimerModel> _timers = [];
  StopwatchModel _stopwatch = StopwatchModel();
  bool _isDarkMode = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  ThemeData get currentTheme => _currentTheme;
  List<TimerModel> get timers => _timers;
  StopwatchModel get stopwatch => _stopwatch;
  bool get isDarkMode => _isDarkMode;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  AppProvider() {
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadSettings();
    await _loadTimers();
    await _loadStopwatch();
    await NotificationService.init();
  }

  // Theme Methods
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _currentTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
    _saveSettings();
    notifyListeners();
  }

  // Timer Methods
  void addTimer(Duration duration, {String? title}) {
    final timer = TimerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      initialDuration: duration,
      remainingDuration: duration,
      createdAt: DateTime.now(),
      title: title,
    );
    _timers.add(timer);
    _saveTimers();
    notifyListeners();
  }

  void startTimer(String id) {
    final timerIndex = _timers.indexWhere((t) => t.id == id);
    if (timerIndex != -1) {
      _timers[timerIndex].start();
      _saveTimers();
      _startTimerTicker(_timers[timerIndex]);
      notifyListeners();
    }
  }

  void pauseTimer(String id) {
    final timerIndex = _timers.indexWhere((t) => t.id == id);
    if (timerIndex != -1) {
      _timers[timerIndex].pause();
      _saveTimers();
      notifyListeners();
    }
  }

  void resetTimer(String id) {
    final timerIndex = _timers.indexWhere((t) => t.id == id);
    if (timerIndex != -1) {
      _timers[timerIndex].reset();
      _saveTimers();
      notifyListeners();
    }
  }

  void deleteTimer(String id) {
    _timers.removeWhere((t) => t.id == id);
    _saveTimers();
    notifyListeners();
  }

  void _startTimerTicker(TimerModel timer) {
    timer.ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      final timerIndex = _timers.indexWhere((t) => t.id == timer.id);
      if (timerIndex == -1 || !_timers[timerIndex].isRunning || _timers[timerIndex].isFinished) {
        t.cancel();
        return;
      }

      _timers[timerIndex].remainingDuration = 
          Duration(seconds: _timers[timerIndex].remainingDuration.inSeconds - 1);
      
      if (_timers[timerIndex].isFinished) {
        _timers[timerIndex].isRunning = false;
        t.cancel();
        _onTimerFinished(_timers[timerIndex]);
        _saveTimers();
      }
      notifyListeners();
    });
  }

  void _onTimerFinished(TimerModel timer) {
    // Show notification
    NotificationService.showNotification(
      timer.id.hashCode, // Convert string ID to int for notification ID
      'Timer Finished',
      timer.title != null ? '${timer.title} completed!' : 'Timer completed!',
    );

    // Play sound if enabled
    if (_soundEnabled) {
      AudioService.playAlarmSound();
    }

    // Vibrate if enabled
    if (_vibrationEnabled) {
      AudioService.vibrate();
    }
  }

  // Stopwatch Methods
  void startStopwatch() {
    _stopwatch.start();
    _startStopwatchTicker();
    _saveStopwatch();
    notifyListeners();
  }

  void pauseStopwatch() {
    _stopwatch.pause();
    _saveStopwatch();
    notifyListeners();
  }

  void resetStopwatch() {
    _stopwatch.reset();
    _saveStopwatch();
    notifyListeners();
  }

  void addLap() {
    _stopwatch.addLap();
    _saveStopwatch();
    notifyListeners();
  }

  void _startStopwatchTicker() {
    _stopwatch.ticker = Timer.periodic(const Duration(milliseconds: 10), (t) {
      if (!_stopwatch.isRunning) {
        t.cancel();
        return;
      }
      
      final now = DateTime.now();
      _stopwatch.elapsed = _stopwatch.pausedDuration + now.difference(_stopwatch.startTime);
      notifyListeners();
    });
  }

  // Settings Methods
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    _saveSettings();
    notifyListeners();
  }

  void toggleVibration() {
    _vibrationEnabled = !_vibrationEnabled;
    _saveSettings();
    notifyListeners();
  }

  // Storage Methods
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    
    if (_isDarkMode) {
      _currentTheme = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      );
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('soundEnabled', _soundEnabled);
    await prefs.setBool('vibrationEnabled', _vibrationEnabled);
  }

  Future<void> _loadTimers() async {
    final prefs = await SharedPreferences.getInstance();
    final timersJson = prefs.getString('timers');
    if (timersJson != null) {
      _timers = TimerModel.listFromJson(timersJson);
      
      // Restart running timers
      for (final timer in _timers.where((t) => t.isRunning && !t.isFinished)) {
        _startTimerTicker(timer);
      }
    }
  }

  Future<void> _saveTimers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('timers', TimerModel.listToJson(_timers));
  }

  Future<void> _loadStopwatch() async {
    final prefs = await SharedPreferences.getInstance();
    final stopwatchJson = prefs.getString('stopwatch');
    if (stopwatchJson != null) {
      _stopwatch = StopwatchModel.fromJson(stopwatchJson);
      
      if (_stopwatch.isRunning) {
        _startStopwatchTicker();
      }
    }
  }

  Future<void> _saveStopwatch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('stopwatch', _stopwatch.toJsonString());
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.ticker?.cancel();
    }
    _stopwatch.ticker?.cancel();
    super.dispose();
  }
}