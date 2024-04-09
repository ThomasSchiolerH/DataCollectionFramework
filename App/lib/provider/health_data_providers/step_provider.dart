import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_app/features/home/services/health_data_services/steps_services.dart';
import 'package:mental_health_app/features/home/services/health_data_services.dart';
import 'package:mental_health_app/models/health_data.dart';
import 'package:mental_health_app/features/home/services/user_input_services.dart';

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
          .subtract(const Duration(days: 1)); // Default to 1 day ago if not set
    }
    return DateTime.parse(lastUploadDateString);
  }

  Future<void> fetchAndUploadSteps(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    UserInputService userInputService = UserInputService();

    // Fetch user settings to determine enabled sensors/data types for upload
    final Map<String, bool> enabledSensors =
        await userInputService.fetchUserSettings(context);

    // Check if steps data is enabled for upload
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
        .totalStepsForToday; // Get the total steps from GetStepsService
    notifyListeners(); // Notify listeners to update the UI
  }
}
