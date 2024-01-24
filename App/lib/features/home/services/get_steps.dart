import 'package:health/health.dart';

class GetStepsService {
  static int last24HourSteps = 0;

  static Future<void> fetchStepsData() async {
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [HealthDataType.STEPS];

    try {
      bool accessGranted = await health.requestAuthorization(types);
      if (accessGranted) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day);
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startOfDay, now, types);
        last24HourSteps = healthData.fold(0, (sum, item) => sum + (item.value as int));
      } else {
        print("Authorization not granted");
      }
    } catch (error) {
      print("An error occurred fetching health data: $error");
    }
  }
}