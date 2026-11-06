import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _waterKey = 'water_intake';
  static const _workoutsKey = 'workouts';
  static const _moodKey = 'mood';
  static const _dateKey = 'last_date';

  // resets daily data if it's a new day
  static Future<void> checkAndResetDaily() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString(_dateKey) ?? '';

    if (lastDate != today) {
      await prefs.setInt(_waterKey, 0);
      await prefs.setStringList(_workoutsKey, []);
      await prefs.setString(_moodKey, '');
      await prefs.setString(_dateKey, today);
    }
  }

  // water intake
  static Future<int> getWater() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_waterKey) ?? 0;
  }

  static Future<void> setWater(int glasses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_waterKey, glasses);
  }

  // workouts
  static Future<List<String>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_workoutsKey) ?? [];
  }

  static Future<void> addWorkout(String workout) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_workoutsKey) ?? [];
    list.add(workout);
    await prefs.setStringList(_workoutsKey, list);
  }

  static Future<void> removeWorkout(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_workoutsKey) ?? [];
    list.removeAt(index);
    await prefs.setStringList(_workoutsKey, list);
  }

  // mood
  static Future<String> getMood() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_moodKey) ?? '';
  }

  static Future<void> setMood(String mood) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_moodKey, mood);
  }
}
