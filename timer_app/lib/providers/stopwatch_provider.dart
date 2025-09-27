import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timer_app/models/stopwatch_model.dart';
import 'package:timer_app/services/storage_service.dart';

class StopwatchProvider with ChangeNotifier {
  StopwatchModel _stopwatch = StopwatchModel();
  Timer? _timer;

  StopwatchModel get stopwatch => _stopwatch;

  StopwatchProvider() {
    _loadStopwatch();
  }

  Future<void> _loadStopwatch() async {
    final savedStopwatch = StorageService.getStopwatch();
    if (savedStopwatch != null) {
      _stopwatch = savedStopwatch;
      
      if (_stopwatch.isRunning) {
        // Calculate elapsed time since last save
        final now = DateTime.now();
        final elapsedSinceSave = now.difference(_stopwatch.startTime);
        _stopwatch.elapsed += elapsedSinceSave;
        _stopwatch.startTime = now;
        _startTimer();
      }
    }
    notifyListeners();
  }

  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.isRunning = true;
      _stopwatch.startTime = DateTime.now();
      _startTimer();
      _saveStopwatch();
      notifyListeners();
    }
  }

  void pause() {
    if (_stopwatch.isRunning) {
      _stopwatch.isRunning = false;
      _stopwatch.pausedDuration = _stopwatch.elapsed;
      _timer?.cancel();
      _saveStopwatch();
      notifyListeners();
    }
  }

  void reset() {
    _timer?.cancel();
    _stopwatch.reset();
    _saveStopwatch();
    notifyListeners();
  }

  void addLap() {
    if (_stopwatch.isRunning) {
      _stopwatch.addLap();
      _saveStopwatch();
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      final now = DateTime.now();
      _stopwatch.elapsed = _stopwatch.pausedDuration + now.difference(_stopwatch.startTime);
      notifyListeners();
    });
  }

  Future<void> _saveStopwatch() async {
    await StorageService.saveStopwatch(_stopwatch);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}