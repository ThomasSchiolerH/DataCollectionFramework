import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/get_exercise_time_service.dart';
import 'package:mental_health_app/features/home/services/health_data_services.dart';

class ExerciseTimeProvider with ChangeNotifier {
  int _exerciseTimeInMinutes = 0;
  bool _isLoading = true;

  int get exerciseTimeInMinutes => _exerciseTimeInMinutes;
  bool get isLoading => _isLoading;

  Future<void> fetchExerciseTime() async {
    _isLoading = true;
    notifyListeners();
    try {
      await GetExerciseTimeService.fetchExerciseTimeData();
      _exerciseTimeInMinutes = GetExerciseTimeService.exerciseTimeInMinutes;
    } catch (e) {
      // Handle the error, maybe log it or set an error message state
      print("Error fetching exercise time: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadExerciseTime(BuildContext context) async {
    print("ExerciseTimeProvider - Preparing to upload exercise time...");
    //_isLoading = true;
    //notifyListeners();

    // Ensure data is fresh before upload
    await fetchExerciseTime();
    print(
        "ExerciseTimeProvider - Uploading exercise time: $_exerciseTimeInMinutes minutes");
    // Assuming you have a similar setup for getting the user and auth token
    HealthDataService().postHealthData(
      context: context,
      type: 'exercise_time',
      value: _exerciseTimeInMinutes,
      unit: 'minutes',
      date: DateTime.now(),
    );
    print("ExerciseTimeProvider - Exercise time upload attempted");
  }
}
