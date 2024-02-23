import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/bmi_data_service.dart';
import 'package:mental_health_app/features/home/services/health_data_services.dart';
import 'dart:async';

class BMIProvider with ChangeNotifier {
  double? _height;
  double? _weight;
  double _bmi = 0.0;

  double? get height => _height;
  double? get weight => _weight;
  double? get bmi => _bmi;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Assuming GetBodyMetricsService is correctly implemented as per previous instructions
  Future<void> fetchBMI() async {
    _isLoading = true;
    notifyListeners();

    double? bmiValue;

    try {
      bmiValue =
          await BMIDataService.fetchBMIData().timeout(Duration(seconds: 10));
    } on TimeoutException catch (_) {
      print("Fetching BMI data timed out.");
      // Handle timeout, e.g., by setting a default state or showing an error message.
    }

    if (bmiValue != null) {
      _bmi = bmiValue;
    } else {
      await fetchHeightAndWeight();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchHeightAndWeight() async {
    _height = await BMIDataService.fetchHeightData();
    _weight = await BMIDataService.fetchWeightData();
    calculateBMI();
    notifyListeners();
  }

  void calculateBMI() {
    if (_height != null && _weight != null) {
      // Ensure height is in meters before calculation
      double heightInMeters = _height!; // Assuming height is already in meters
      _bmi = _weight! / (heightInMeters * heightInMeters);
      notifyListeners(); // Notify listeners if BMI is calculated manually
    }
  }

  Future<void> uploadBMI(BuildContext context) async {
    await fetchBMI();

    // TODO: Add logic here to check if a full day has elapsed since the last upload

    // Call HealthDataService to upload the BMI
    HealthDataService().postHealthData(
      context: context,
      type: 'BMI',
      value: _bmi,
      unit: 'kg/m2',
      date: DateTime.now(),
    );
  }
}
