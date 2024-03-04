import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class GetSleepService {
  static int getSleepMinutes = 0;
  static DateTime? lastFetchedDate;
  static HealthFactory health = HealthFactory();

  // Corrected: Moved permission request into a separate method.
  static Future<void> requestPermissions() async {
    bool permissionGranted =
        await Permission.activityRecognition.request().isGranted &&
            await Permission.location
                .request()
                .isGranted; // Location for iOS workout data
    if (!permissionGranted) {
      // Handle lack of permissions appropriately.
      print("Activity recognition or location permissions not granted.");
      return;
    }
    bool healthPermissionGranted = await health.requestAuthorization(
        [HealthDataType.SLEEP_ASLEEP, HealthDataType.SLEEP_AWAKE]);
    if (!healthPermissionGranted) {
      // Handle lack of health permissions appropriately.
      print("Health permissions not granted.");
      return;
    }
  }

  static Future<void> fetchSleepData() async {
    List<HealthDataType> types = [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE
    ];

    try {
      bool accessGranted = await health.requestAuthorization(types);
      if (accessGranted) {
        DateTime now = DateTime.now();
        DateTime startOfYesterday = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 1));
        DateTime endOfYesterday = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(seconds: 1));

        List<HealthDataPoint> sleepData = await health.getHealthDataFromTypes(
            startOfYesterday, endOfYesterday, types);
        // Moved calculation call here and correctly update getSleepMinutes.
        getSleepMinutes = calculateTotalSleepMinutes(sleepData);

        lastFetchedDate = now; // Update last fetched date.
        if (sleepData.isEmpty) {
          print('No sleep data available for the specified period.');
        }
      } else {
        print("Access not granted for Health data types.");
      }
    } catch (error) {
      print("Exception in fetchSleepData: $error");
    }
  }

  // Corrected: Moved the method outside of fetchSleepData for clarity.
  static int calculateTotalSleepMinutes(List<HealthDataPoint> sleepData) {
    int totalMinutes = 0;
    for (HealthDataPoint point in sleepData) {
      DateTime start = point.dateFrom;
      DateTime end = point.dateTo;
      int duration = end.difference(start).inMinutes;
      totalMinutes += duration;
    }
    return totalMinutes;
  }

  static bool shouldUploadSleep() {
    if (lastFetchedDate == null) return true;
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    return lastFetchedDate!.isBefore(startOfToday);
  }
}
