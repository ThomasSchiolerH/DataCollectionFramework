import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_app/features/home/services/health_data_services/get_steps.dart';
import 'package:mental_health_app/features/home/services/health_data_services.dart';
import 'package:mental_health_app/models/health_data.dart';

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
      return DateTime.now().subtract(Duration(days: 1)); // Default to 1 day ago if not set
    }
    return DateTime.parse(lastUploadDateString);
  }

  Future<void> fetchAndUploadSteps(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    DateTime lastUploadDate = await _getLastUploadDate();
    DateTime now = DateTime.now();
    DateTime startOfCurrentHour = DateTime(now.year, now.month, now.day, now.hour);
    print("Fetching and uploading steps data...");

    List<HealthData> hourlySteps = await GetStepsService.fetchHourlyStepsData(lastUploadDate, startOfCurrentHour);
    if (hourlySteps.isNotEmpty) {
      // Summarize the hourly steps into a total count for display purposes.
      _steps = hourlySteps.fold(0, (sum, data) => sum + data.value.toInt());

      HealthDataService().uploadHealthData(
        context: context,
        healthDataPoints: hourlySteps,
      );
      await _updateLastUploadDate(now);
      print("Fetched ${hourlySteps.length} hourly data points.");
    }
    await GetStepsService.fetchTotalStepsForToday();
    _isLoading = false;
    notifyListeners();
  }

    Future<void> fetchTotalStepsForToday() async {
    await GetStepsService.fetchTotalStepsForToday();
    _steps = GetStepsService.totalStepsForToday; // Get the total steps from GetStepsService
    notifyListeners(); // Notify listeners to update the UI
  }
}
