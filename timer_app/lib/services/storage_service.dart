import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_app/models/timer_model.dart';
import 'package:timer_app/models/stopwatch_model.dart';

class StorageService {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveTimers(List<TimerModel> timers) async {
    final timersJson = timers.map((timer) => timer.toJson()).toList();
    await prefs.setString('timers', json.encode(timersJson));
  }

  static List<TimerModel> getTimers() {
    final timersJson = prefs.getString('timers');
    if (timersJson == null) return [];
    
    try {
      final List<dynamic> jsonList = json.decode(timersJson);
      return jsonList.map((json) => TimerModel.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing timers: $e');
      return [];
    }
  }

  static Future<void> saveStopwatch(StopwatchModel stopwatch) async {
    await prefs.setString('stopwatch', json.encode(stopwatch.toJson()));
  }

  static StopwatchModel? getStopwatch() {
    final stopwatchJson = prefs.getString('stopwatch');
    if (stopwatchJson == null) return null;
    
    try {
      return StopwatchModel.fromJson(json.decode(stopwatchJson));
    } catch (e) {
      print('Error parsing stopwatch: $e');
      return null;
    }
  }

  static Future<void> clearAllData() async {
    await prefs.clear();
  }
}