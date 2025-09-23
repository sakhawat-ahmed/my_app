import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timer_app/models/timer_model.dart';
import 'package:timer_app/models/stopwatch_model.dart';
import 'package:timer_app/models/lap_model.dart';

class StorageService {
  static late Box<TimerModel> timersBox;
  static late Box<StopwatchModel> stopwatchBox;
  static late SharedPreferences prefs;

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Register adapters
    Hive.registerAdapter(TimerModelAdapter());
    Hive.registerAdapter(StopwatchModelAdapter());
    Hive.registerAdapter(LapModelAdapter());
    Hive.registerAdapter(DurationAdapter());

    // Open boxes
    timersBox = await Hive.openBox<TimerModel>('timers');
    stopwatchBox = await Hive.openBox<StopwatchModel>('stopwatch');
    
    // Initialize shared preferences
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveTimers(List<TimerModel> timers) async {
    await timersBox.clear();
    for (final timer in timers) {
      await timersBox.put(timer.id, timer);
    }
  }

  static List<TimerModel> getTimers() {
    return timersBox.values.toList();
  }

  static Future<void> saveStopwatch(StopwatchModel stopwatch) async {
    await stopwatchBox.put('current', stopwatch);
  }

  static StopwatchModel? getStopwatch() {
    return stopwatchBox.get('current');
  }

  static Future<void> clearAllData() async {
    await timersBox.clear();
    await stopwatchBox.clear();
    await prefs.clear();
  }
}

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 3;

  @override
  Duration read(BinaryReader reader) {
    return Duration(microseconds: reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inMicroseconds);
  }
}