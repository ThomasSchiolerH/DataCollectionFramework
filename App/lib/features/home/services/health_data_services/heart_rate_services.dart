import 'package:health/health.dart';
import 'package:mental_health_app/models/health_data.dart';

class HeartRateServices {
  static HealthFactory health = HealthFactory();
  static double averageHeartRateForToday = 0;
  static DateTime? lastFetchedDate;

  static Future<List<HealthData>> fetchHourlyHeartRate(
      DateTime startDate, DateTime endDate) async {
    List<HealthData> hourlyHeartRateData = [];
    List<HealthDataType> types = [HealthDataType.HEART_RATE];
    bool accessGranted = await health.requestAuthorization(types);
    if (!accessGranted) {
      print("Authorization not granted");
      return hourlyHeartRateData;
    }

    DateTime currentTime = startDate;
    while (currentTime.isBefore(endDate)) {
      DateTime endOfHour = DateTime(currentTime.year, currentTime.month,
              currentTime.day, currentTime.hour)
          .add(const Duration(hours: 1));
      // Adjust endOfHour if it exceeds endDate
      if (endOfHour.isAfter(endDate)) {
        endOfHour = endDate;
      }

      List<HealthDataPoint> dataPoints =
          await health.getHealthDataFromTypes(currentTime, endOfHour, types);
      num heart_rate = 0;
      for (var dataPoint in dataPoints) {
        if (dataPoint.type == HealthDataType.HEART_RATE) {
          NumericHealthValue numericValue =
              dataPoint.value as NumericHealthValue;
          heart_rate += numericValue.numericValue;
        }
      }

      if (heart_rate > 0) {
        hourlyHeartRateData.add(HealthData(
          type: 'HEART_RATE',
          value: heart_rate,
          unit: 'BEATS_PER_MINUTE',
          date: currentTime,
        ));
      }

      currentTime = endOfHour;
    }

    return hourlyHeartRateData;
  }

static Future<void> fetchTotalHeartRateForToday() async {
    List<HealthDataType> types = [HealthDataType.HEART_RATE];

    bool accessGranted = await health.requestAuthorization(types);
    if (!accessGranted) {
      print("Authorization not granted");
      return;
    }

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
  
    try {
      List<HealthDataPoint> dataPoints = await health.getHealthDataFromTypes(startOfDay, now, types);
      int sumHeartRate = 0;
      int count = 0;
      
      for (var dataPoint in dataPoints) {
        if (dataPoint.type == HealthDataType.HEART_RATE) {
          NumericHealthValue numericValue = dataPoint.value as NumericHealthValue;
          sumHeartRate += numericValue.numericValue.toInt();
          count++; // Increment count for each heart rate data point
        }
      }

      // Calculate average if count is greater than 0 to avoid division by zero
      averageHeartRateForToday = count > 0 ? sumHeartRate / count : 0;
      lastFetchedDate = DateTime.now();
    } catch (error) {
      print("An error occurred fetching health data: $error");
      // Handle error, possibly resetting averageHeartRateForToday or setting it to a specific error value
    }
  }
}
