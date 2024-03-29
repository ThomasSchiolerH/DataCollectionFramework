import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_app/features/home/services/health_data_services/heart_rate_services.dart';
import 'package:mental_health_app/features/home/services/health_data_services.dart';
import 'package:mental_health_app/models/health_data.dart';

class HeartRateProvider with ChangeNotifier {
  bool _isLoading = true;
  int _heart_rate = 0;

  bool get isLoading => _isLoading;
  int get heart_rate => _heart_rate;

  Future<void> _updateLastUploadDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastHeartRateUploadDate', date.toIso8601String());
  }

  Future<DateTime> _getLastUploadDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastUploadDateString = prefs.getString('lastHeartRateUploadDate');
    if (lastUploadDateString == null) {
      return DateTime.now().subtract(Duration(days: 1)); // Default to 1 day ago if not set
    }
    return DateTime.parse(lastUploadDateString);
  }

  Future<void> fetchAndUploadHeartRate(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    DateTime lastUploadDate = await _getLastUploadDate();
    DateTime now = DateTime.now();
    DateTime startOfCurrentHour = DateTime(now.year, now.month, now.day, now.hour);
    print("Fetching and uploading heart rate data...");

    List<HealthData> hourlyHeartRate = await HeartRateServices.fetchHourlyHeartRate(lastUploadDate, startOfCurrentHour);
    if (hourlyHeartRate.isNotEmpty) {
      // Summarize the hourly heart rate into a total count for display purposes.
      _heart_rate = hourlyHeartRate.fold(0, (sum, data) => sum + data.value.toInt());

      HealthDataService().uploadHealthData(
        context: context,
        healthDataPoints: hourlyHeartRate,
      );
      await _updateLastUploadDate(now);
      print("Fetched ${hourlyHeartRate.length} hourly data points.");
    }
    await HeartRateServices.fetchTotalHeartRateForToday();
    _isLoading = false;
    notifyListeners();
  }

    Future<void> fetchTotalHeartRateForToday() async {
    _heart_rate = 0;
    await HeartRateServices.fetchTotalHeartRateForToday();
    _heart_rate = HeartRateServices.averageHeartRateForToday.toInt(); // Get the total heart rate from HeartRateServices and cast it to 'int'
    notifyListeners(); // Notify listeners to update the UI
  }
}
