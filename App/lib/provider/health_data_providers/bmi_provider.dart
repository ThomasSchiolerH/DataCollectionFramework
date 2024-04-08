import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/health_data_services/bmi_data_service.dart';
import 'package:mental_health_app/features/home/services/health_data_services.dart';
import 'package:mental_health_app/features/home/services/user_input_services.dart';
import 'package:mental_health_app/models/health_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class BMIProvider with ChangeNotifier {
  double _bmi = 0.0;
  bool _isLoading = true;

  double get bmi => _bmi;
  bool get isLoading => _isLoading;

  Future<void> _updateLastUploadDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastBMIUploadDate', date.toIso8601String());
  }

  Future<DateTime> _getLastUploadDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastUploadDateString = prefs.getString('lastBMIUploadDate');
    if (lastUploadDateString == null) {
      return DateTime.now()
          .subtract(Duration(days: 1)); // Default to 1 day ago if not set
    }
    return DateTime.parse(lastUploadDateString);
  }

  Future<void> fetchAndUploadBMI(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    UserInputService userInputService = UserInputService();

    // Fetch user settings to determine enabled sensors/data types for upload
    final Map<String, bool> enabledSensors =
        await userInputService.fetchUserSettings(context);

    // Check if steps data is enabled for upload
    if (enabledSensors['BMI'] ?? false) {
      DateTime lastUploadDate = await _getLastUploadDate();
      DateTime now = DateTime.now();

      if (lastUploadDate.isBefore(DateTime(now.year, now.month, now.day))) {
        double? height = await BMIDataService.fetchHeightData();
        double? weight = await BMIDataService.fetchWeightData();

        if (height != null && weight != null) {
          // Assuming height in meters and weight in kg, calculate BMI
          _bmi = weight / (height * height);
          // Upload the BMI data
          HealthDataService().uploadHealthData(
            context: context,
            healthDataPoints: [
              HealthData(
                type: 'BMI',
                value: _bmi,
                unit: 'kg/m^2',
                date: now,
              )
            ],
          );
          _updateLastUploadDate(now);
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTotalBMIForToday() async {
    _isLoading = true;
    notifyListeners();

    // Directly use the BMI value if fetched earlier or calculate if not
    if (_bmi == 0.0) {
      double? height = await BMIDataService.fetchHeightData();
      double? weight = await BMIDataService.fetchWeightData();
      if (height != null && weight != null) {
        _bmi = weight / (height * height);
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
