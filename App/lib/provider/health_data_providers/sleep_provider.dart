import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/health_data_services/get_sleep.dart';
import 'package:mental_health_app/features/home/services/health_data_services.dart';
import 'package:mental_health_app/models/health_data.dart';
import 'package:provider/provider.dart';

class SleepProvider with ChangeNotifier {
  int _sleepMinutes = 0;
  bool _isLoading = true;

  int get sleepMinutes => _sleepMinutes;
  bool get isLoading => _isLoading;

  Future<void> fetchSleep(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // Assuming fetchSleepData now correctly updates _sleepMinutes based on fetched data
    await GetSleepService.fetchSleepData();
    _sleepMinutes = GetSleepService.getSleepMinutes;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> uploadSleep(BuildContext context) async {
    await fetchSleep(context); // Ensure sleep data is fetched before attempting to upload

    // Use HealthDataService's uploadHealthData for flexibility
    Provider.of<HealthDataService>(context, listen: false).uploadHealthData(
      context: context,
      healthDataPoints: [
        HealthData(
          type: 'sleep',
          value: _sleepMinutes,
          unit: 'minutes',
          date: DateTime.now(), // Consider using the actual sleep data date if available
        )
      ],
    );
  }
}
