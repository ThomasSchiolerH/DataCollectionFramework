import 'package:health/health.dart';
import 'package:mental_health_app/models/health_data.dart';

class GetEnergyService {
  static HealthFactory health = HealthFactory();
  static int totalEnergyForToday = 0;
  static DateTime? lastFetchedDate;

  // Request permissions to access health data and fetch hourly energy data from the device
  static Future<List<HealthData>> fetchHourlyEnergyData(
      DateTime startDate, DateTime endDate) async {
    List<HealthData> hourlyEnergyData = [];
    List<HealthDataType> types = [HealthDataType.ACTIVE_ENERGY_BURNED];
    bool accessGranted = await health.requestAuthorization(types);
    if (!accessGranted) {
      print("Authorization not granted");
      return hourlyEnergyData;
    }

    DateTime currentTime = startDate;
    while (currentTime.isBefore(endDate)) {
      DateTime endOfHour = DateTime(currentTime.year, currentTime.month,
              currentTime.day, currentTime.hour)
          .add(const Duration(hours: 1));
      if (endOfHour.isAfter(endDate)) {
        endOfHour = endDate;
      }

      List<HealthDataPoint> dataPoints =
          await health.getHealthDataFromTypes(currentTime, endOfHour, types);
      num energy = 0;
      for (var dataPoint in dataPoints) {
        if (dataPoint.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
          NumericHealthValue numericValue =
              dataPoint.value as NumericHealthValue;
          energy += numericValue.numericValue;
        }
      }

      if (energy > 0) {
        hourlyEnergyData.add(HealthData(
          type: 'active_energy_burned',
          value: energy,
          unit: 'calories',
          date: currentTime,
        ));
      }

      currentTime = endOfHour;
    }

    return hourlyEnergyData;
  }

  // Fetches total energy for today
  static Future<int> fetchTotalEnergyForToday() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    List<HealthData> todayEnergyData =
        await fetchHourlyEnergyData(startOfDay, now);

    int totalTodayEnergy =
        todayEnergyData.fold(0, (sum, data) => sum + data.value.toInt());
    totalEnergyForToday = totalTodayEnergy;

    return totalTodayEnergy;
  }
}
