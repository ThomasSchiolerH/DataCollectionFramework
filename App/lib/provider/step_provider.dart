import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/get_steps.dart';

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
}

