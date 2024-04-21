import 'package:flutter/material.dart';
import 'package:mental_health_app/features/healthdata/services/sensor_services/get_exercise_time_service.dart';
import 'package:mental_health_app/features/healthdata/services/health_data_services.dart';
import 'package:mental_health_app/features/user_input/services/user_input_services.dart';
import 'package:mental_health_app/models/health_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseTimeProvider with ChangeNotifier {
  bool _isLoading = true;
  int _totalExerciseTime = 0; 

  bool get isLoading => _isLoading;
  int get totalExerciseTime => _totalExerciseTime;

  // Updates the last upload date in the shared preferences
  Future<void> _updateLastUploadDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastExerciseUploadDate', date.toIso8601String());
  }

  // Fetches the last upload date from the shared preferences
  Future<DateTime> _getLastUploadDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastUploadDateString =
        prefs.getString('lastExerciseUploadDate');
    if (lastUploadDateString == null) {
      return DateTime.now().subtract(const Duration(days: 1));
    }
    return DateTime.parse(lastUploadDateString);
  }

  // Fetches the exercise time data from the backend and uploads it
  Future<void> fetchAndUploadExerciseTime(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    UserInputService userInputService = UserInputService();

    final Map<String, bool> enabledSensors =
        await userInputService.fetchUserSettings(context);

    if (enabledSensors['exerciseTime'] ?? false) {
      DateTime lastUploadDate = await _getLastUploadDate();
      DateTime now = DateTime.now();
      DateTime startOfCurrentHour =
          DateTime(now.year, now.month, now.day, now.hour);

      List<HealthData> hourlyExerciseData =
          await GetExerciseTimeService.fetchHourlyExerciseTimeData(
              lastUploadDate, startOfCurrentHour);
      if (hourlyExerciseData.isNotEmpty) {
        _totalExerciseTime =
            hourlyExerciseData.fold(0, (sum, data) => sum + data.value.toInt());
        await Provider.of<HealthDataService>(context, listen: false)
            .uploadHealthData(
          context: context,
          healthDataPoints: hourlyExerciseData,
        );
        await _updateLastUploadDate(now);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetches the total exercise time for today
  Future<void> fetchTotalExerciseTimeForToday() async {
    _isLoading = true;
    notifyListeners();

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    List<HealthData> hourlyExerciseData =
        await GetExerciseTimeService.fetchHourlyExerciseTimeData(
            startOfDay, now);

    _totalExerciseTime =
        hourlyExerciseData.fold(0, (sum, data) => sum + data.value.toInt());

    _isLoading = false;
    notifyListeners();
  }
}
