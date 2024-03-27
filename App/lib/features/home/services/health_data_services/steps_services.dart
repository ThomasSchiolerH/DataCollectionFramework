import 'package:health/health.dart';
import 'package:mental_health_app/models/health_data.dart';

class GetStepsService {
  static HealthFactory health = HealthFactory();
  static int totalStepsForToday = 0;
  static DateTime? lastFetchedDate;

  static Future<List<HealthData>> fetchHourlyStepsData(
      DateTime startDate, DateTime endDate) async {
    List<HealthData> hourlyStepsData = [];
    List<HealthDataType> types = [HealthDataType.STEPS];
    bool accessGranted = await health.requestAuthorization(types);
    if (!accessGranted) {
      print("Authorization not granted");
      return hourlyStepsData;
    }

    DateTime currentTime = startDate;
    while (currentTime.isBefore(endDate)) {
      DateTime endOfHour = DateTime(currentTime.year, currentTime.month,
              currentTime.day, currentTime.hour)
          .add(Duration(hours: 1));
      // Adjust endOfHour if it exceeds endDate
      if (endOfHour.isAfter(endDate)) {
        endOfHour = endDate;
      }

      List<HealthDataPoint> dataPoints =
          await health.getHealthDataFromTypes(currentTime, endOfHour, types);
      num steps = 0;
      for (var dataPoint in dataPoints) {
        if (dataPoint.type == HealthDataType.STEPS) {
          NumericHealthValue numericValue =
              dataPoint.value as NumericHealthValue;
          steps += numericValue.numericValue;
        }
      }

      if (steps > 0) {
        hourlyStepsData.add(HealthData(
          type: 'steps',
          value: steps,
          unit: 'steps',
          date: currentTime,
        ));
      }

      currentTime = endOfHour;
    }

    return hourlyStepsData;
  }

  static Future<void> fetchTotalStepsForToday() async {
    List<HealthDataType> types = [HealthDataType.STEPS];

    bool accessGranted = await health.requestAuthorization(types);
    if (!accessGranted) {
      print("Authorization not granted");
      return;
    }

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    try {
      int? totalSteps = await health.getTotalStepsInInterval(startOfDay, now);
      totalStepsForToday = totalSteps ?? 0;
      lastFetchedDate = DateTime.now();
    } catch (error) {
      print("An error occurred fetching health data: $error");
    }
  }
}
