import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/get_steps.dart';
import 'package:mental_health_app/features/home/services/health_data_services.dart';

class StepProvider with ChangeNotifier {
  int _steps = 0;
  bool _isLoading = true;

  int get steps => _steps;
  bool get isLoading => _isLoading;

  Future<void> fetchSteps() async {
    _isLoading = true;
    notifyListeners();

    await GetStepsService.fetchStepsData();
    _steps = GetStepsService.getSteps;
    _isLoading = false;

    notifyListeners();
  }

  Future<void> uploadSteps(BuildContext context) async {
    await fetchSteps(); // Fetch the latest step count
    // Now, _steps contains the latest step count

    // TODO: Add logic here to check if a full day has elapsed since the last upload

    // Call HealthDataService to upload the steps
    HealthDataService().postHealthData(
      context: context,
      type: 'steps',
      value: _steps,
      unit: 'steps',
      date: DateTime.now(),
    );
  }
}
