import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timer_app/models/timer_model.dart';
import 'package:timer_app/services/storage_service.dart';
import 'package:timer_app/services/notification_service.dart';
import 'package:timer_app/services/audio_service.dart';
import 'package:timer_app/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class TimerProvider with ChangeNotifier {
  final List<TimerModel> _timers = [];
  final Map<String, Timer> _timerTickCallbacks = {};

  List<TimerModel> get timers => _timers;

  TimerProvider() {
    _loadTimers();
  }

  Future<void> _loadTimers() async {
    final savedTimers = StorageService.getTimers();
    _timers.addAll(savedTimers);
    
    // Restart running timers
    for (final timer in _timers.where((t) => t.isRunning && !t.isFinished)) {
      _startTimerTick(timer);
    }
    
    notifyListeners();
  }

  void addTimer(Duration duration, {String? title}) {
    final timer = TimerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      initialDuration: duration,
      remainingDuration: duration,
      isRunning: false,
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
      _timers[timerIndex] = _timers[timerIndex].copyWith(isRunning: true);
      _startTimerTick(_timers[timerIndex]);
      _saveTimers();
      notifyListeners();
    }
  }

  void pauseTimer(String id) {
    final timerIndex = _timers.indexWhere((t) => t.id == id);
    if (timerIndex != -1) {
      _timers[timerIndex] = _timers[timerIndex].copyWith(isRunning: false);
      _timerTickCallbacks[id]?.cancel();
      _timerTickCallbacks.remove(id);
      _saveTimers();
      notifyListeners();
    }
  }

  void resetTimer(String id) {
    final timerIndex = _timers.indexWhere((t) => t.id == id);
    if (timerIndex != -1) {
      _timerTickCallbacks[id]?.cancel();
      _timerTickCallbacks.remove(id);
      
      _timers[timerIndex] = _timers[timerIndex].copyWith(
        isRunning: false,
        remainingDuration: _timers[timerIndex].initialDuration,
      );
      
      _saveTimers();
      notifyListeners();
    }
  }

  void deleteTimer(String id) {
    _timerTickCallbacks[id]?.cancel();
    _timerTickCallbacks.remove(id);
    _timers.removeWhere((t) => t.id == id);
    _saveTimers();
    notifyListeners();
  }

  void _startTimerTick(TimerModel timer) {
    _timerTickCallbacks[timer.id] = Timer.periodic(Duration(seconds: 1), (t) {
      final timerIndex = _timers.indexWhere((t) => t.id == timer.id);
      if (timerIndex == -1) {
        t.cancel();
        return;
      }

      final newDuration = _timers[timerIndex].remainingDuration - Duration(seconds: 1);
      
      if (newDuration.inSeconds <= 0) {
        // Timer finished
        _timers[timerIndex] = _timers[timerIndex].copyWith(
          isRunning: false,
          remainingDuration: Duration.zero,
        );
        
        t.cancel();
        _timerTickCallbacks.remove(timer.id);
        
        // Notify and play sound
        _notifyTimerFinished(_timers[timerIndex]);
        
        _saveTimers();
        notifyListeners();
      } else {
        _timers[timerIndex] = _timers[timerIndex].copyWith(
          remainingDuration: newDuration,
        );
        notifyListeners();
      }
    });
  }

  void _notifyTimerFinished(TimerModel timer) {
    final settings = Provider.of<SettingsProvider>(Navigator.of(context).context, listen: false);
    
    if (settings.notificationsEnabled) {
      NotificationService.showTimerNotification(
        timer.id,
        'Timer Finished',
        timer.title != null ? '${timer.title} has completed!' : 'Your timer has completed!',
      );
    }
    
    if (settings.soundEnabled) {
      AudioService.playSound(settings.selectedSound);
    }
    
    if (settings.vibrationEnabled) {
      AudioService.vibrate();
    }
  }

  Future<void> _saveTimers() async {
    await StorageService.saveTimers(_timers);
  }

  @override
  void dispose() {
    for (final timer in _timerTickCallbacks.values) {
      timer.cancel();
    }
    _timerTickCallbacks.clear();
    super.dispose();
  }
}