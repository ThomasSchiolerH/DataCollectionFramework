import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_app/features/program/services/health_data_services/steps_services.dart';
import 'package:mental_health_app/features/program/services/health_data_services.dart';
import 'package:mental_health_app/models/health_data.dart';
import 'package:mental_health_app/features/program/services/user_input_services.dart';

class StepProvider with ChangeNotifier {
  bool _isLoading = true;
  int _steps = 0;

  bool get isLoading => _isLoading;
  int get steps => _steps;

  Future<void> _updateLastUploadDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastUploadDate', date.toIso8601String());
  }

  Future<DateTime> _getLastUploadDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastUploadDateString = prefs.getString('lastUploadDate');
    if (lastUploadDateString == null) {
      return DateTime.now()
          .subtract(const Duration(days: 1)); 
    }
    return DateTime.parse(lastUploadDateString);
  }

  Future<void> fetchAndUploadSteps(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    UserInputService userInputService = UserInputService();

    final Map<String, bool> enabledSensors =
        await userInputService.fetchUserSettings(context);

    if (enabledSensors['steps'] ?? false) {
      DateTime lastUploadDate = await _getLastUploadDate();
      DateTime now = DateTime.now();
      DateTime startOfCurrentHour =
          DateTime(now.year, now.month, now.day, now.hour);
      print("Fetching and uploading steps data...");

      List<HealthData> hourlySteps = await GetStepsService.fetchHourlyStepsData(
          lastUploadDate, startOfCurrentHour);
      if (hourlySteps.isNotEmpty) {
        _steps = hourlySteps.fold(0, (sum, data) => sum + data.value.toInt());

        HealthDataService().uploadHealthData(
          context: context,
          healthDataPoints: hourlySteps,
        );
        await _updateLastUploadDate(now);
        print("Fetched ${hourlySteps.length} hourly data points.");
      }
    } else {
      print("Steps data upload is disabled by admin.");
    }

    await GetStepsService.fetchTotalStepsForToday();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTotalStepsForToday() async {
    _steps = 0;
    await GetStepsService.fetchTotalStepsForToday();
    _steps = GetStepsService
        .totalStepsForToday; 
    notifyListeners(); 
  }
}
