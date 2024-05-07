import 'package:flutter/material.dart';
import 'package:mental_health_app/features/user_input/services/user_input_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_app/features/healthdata/services/sensor_services/heart_rate_services.dart';
import 'package:mental_health_app/features/healthdata/services/health_data_services.dart';
import 'package:mental_health_app/models/health_data.dart';

class HeartRateProvider with ChangeNotifier {
  bool _isLoading = true;
  int _heart_rate = 0;

  bool get isLoading => _isLoading;
  int get heart_rate => _heart_rate;

  // Updates the last upload date in the shared preferences
  Future<void> _updateLastUploadDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastHeartRateUploadDate', date.toIso8601String());
  }

  // Fetches the last upload date from the shared preferences
  Future<DateTime> _getLastUploadDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastUploadDateString =
        prefs.getString('lastHeartRateUploadDate');
    if (lastUploadDateString == null) {
      return DateTime.now()
          .subtract(const Duration(days: 1)); 
    }
    return DateTime.parse(lastUploadDateString);
  }

  // Fetches the heart rate data and uploads it
  Future<void> fetchAndUploadHeartRate(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    UserInputService userInputService = UserInputService();

    final Map<String, bool> enabledSensors =
        await userInputService.fetchUserSettings(context);

    if (enabledSensors['heartRate'] ?? false) {
      DateTime lastUploadDate = await _getLastUploadDate();
      DateTime now = DateTime.now();
      DateTime startOfCurrentHour =
          DateTime(now.year, now.month, now.day, now.hour);
      print("Fetching and uploading heart rate data...");

      List<HealthData> hourlyHeartRate =
          await HeartRateServices.fetchHourlyHeartRate(
              lastUploadDate, startOfCurrentHour);
      if (hourlyHeartRate.isNotEmpty) {
        _heart_rate =
            hourlyHeartRate.fold(0, (sum, data) => sum + data.value.toInt());

        HealthDataService().uploadHealthData(
          context: context,
          healthDataPoints: hourlyHeartRate,
        );
        await _updateLastUploadDate(now);
        print("Fetched ${hourlyHeartRate.length} hourly data points.");
      }
    }
    await HeartRateServices.fetchTotalHeartRateForToday();
    _isLoading = false;
    notifyListeners();
  }

  // Fetches the total heart rate for today
  Future<void> fetchTotalHeartRateForToday() async {
    _heart_rate = 0;
    await HeartRateServices.fetchTotalHeartRateForToday();
    _heart_rate = HeartRateServices.averageHeartRateForToday
        .toInt();
    notifyListeners(); 
  }
}
