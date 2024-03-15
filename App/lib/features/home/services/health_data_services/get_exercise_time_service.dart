import 'package:health/health.dart';
import 'package:mental_health_app/models/health_data.dart';

class GetExerciseTimeService {
  static HealthFactory health = HealthFactory();
  static int exerciseTimeInMinutes = 0;
  static DateTime? lastFetchedDate;

  static Future<List<HealthData>> fetchHourlyExerciseTimeData(DateTime startDate, DateTime endDate) async {
    List<HealthData> hourlyExerciseData = [];
    List<HealthDataType> types = [HealthDataType.EXERCISE_TIME];
    bool accessGranted = await health.requestAuthorization(types);
    if (!accessGranted) {
      print("Authorization not granted");
      return hourlyExerciseData;
    }

    DateTime currentTime = startDate;
    while (currentTime.isBefore(endDate)) {
      DateTime endOfHour = DateTime(currentTime.year, currentTime.month, currentTime.day, currentTime.hour).add(Duration(hours: 1));
      if (endOfHour.isAfter(endDate)) {
        endOfHour = endDate;
      }

      List<HealthDataPoint> dataPoints = await health.getHealthDataFromTypes(currentTime, endOfHour, types);
      double exerciseTime = 0;
      for (var dataPoint in dataPoints) {
        if (dataPoint.type == HealthDataType.EXERCISE_TIME) {
          NumericHealthValue numericValue = dataPoint.value as NumericHealthValue;
          exerciseTime += numericValue.numericValue;
        }
      }

      if (exerciseTime > 0) {
        hourlyExerciseData.add(HealthData(
          type: 'exercise_time',
          value: exerciseTime,
          unit: 'minutes',
          date: currentTime,
        ));
      }

      currentTime = endOfHour;
    }

    return hourlyExerciseData;
  }


static Future<int> fetchTotalExerciseTimeForToday() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    List<HealthData> todayExerciseData = await fetchHourlyExerciseTimeData(startOfDay, now);

    int totalTodayExerciseTime = todayExerciseData.fold(0, (sum, data) => sum + data.value.toInt());
    exerciseTimeInMinutes = totalTodayExerciseTime;

    return totalTodayExerciseTime; // Return the total for further processing or updating UI
}

}
