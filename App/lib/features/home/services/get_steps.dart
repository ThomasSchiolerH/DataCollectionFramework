import 'package:health/health.dart';

class GetStepsService {
  static int getSteps = 0;

  static Future<void> fetchStepsData() async {
    HealthFactory health = HealthFactory();
    // Choose data to fetch
    List<HealthDataType> types = [HealthDataType.STEPS];

    try {
      bool accessGranted = await health.requestAuthorization(types);
      if (accessGranted) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day);

        // Fetch steps
        int? steps = await health.getTotalStepsInInterval(startOfDay, now);

        // Update step count
        getSteps = steps ?? 0;
      } else {
        print("Authorization not granted");
      }
    } catch (error) {
      print("An error occurred fetching health data: $error");
    }
  }
}
