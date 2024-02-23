import 'package:health/health.dart';

class GetExerciseTimeService {
  static int exerciseTimeInMinutes = 0;
  static DateTime? lastFetchedDate;

  static Future<void> fetchExerciseTimeData() async {
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [HealthDataType.EXERCISE_TIME];

    try {
      bool accessGranted = await health.requestAuthorization(types);
      if (accessGranted) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day);
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(startOfDay, now, types);

        // Adjusted summation logic to handle double values
        double totalExerciseTime = healthData.fold(
            0.0, (sum, dataPoint) => sum + (dataPoint.value as double));

        // Convert the total exercise time to an integer if necessary
        exerciseTimeInMinutes = totalExerciseTime.toInt();

        lastFetchedDate = DateTime.now();
      } else {
        print("Authorization not granted");
      }
    } catch (error) {
      print("An error occurred fetching exercise data: $error");
    }
  }

  static bool shouldUploadExerciseTime() {
    if (lastFetchedDate == null) return true;
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    return lastFetchedDate!.isBefore(startOfToday);
  }
}
