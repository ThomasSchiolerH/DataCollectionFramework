import 'package:health/health.dart';

class BMIDataService {
  static final HealthFactory health = HealthFactory();
  static DateTime? lastFetchedDate;

  // Add a method to request permissions for all data types at once
  static Future<bool> requestPermissions() async {
    List<HealthDataType> types = [
      HealthDataType.HEIGHT,
      HealthDataType.WEIGHT,
      HealthDataType.BODY_MASS_INDEX,
    ];
    return await health.requestAuthorization(types);
  }

  static Future<double?> fetchHeightData() async {
    return await fetchHealthData(HealthDataType.HEIGHT);
  }

  static Future<double?> fetchWeightData() async {
    return await fetchHealthData(HealthDataType.WEIGHT);
  }

  static Future<double?> fetchBMIData() async {
    return await fetchHealthData(HealthDataType.BODY_MASS_INDEX);
  }

  static Future<double?> fetchHealthData(HealthDataType dataType) async {
    // Ensure permissions are requested before attempting to fetch data
    bool accessGranted = await requestPermissions();
    if (accessGranted) {
      DateTime now = DateTime.now();
      DateTime startOfRecord = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 365));
      List<HealthDataPoint> dataPoints =
          await health.getHealthDataFromTypes(startOfRecord, now, [dataType]);
      dataPoints = HealthFactory.removeDuplicates(dataPoints);
      if (dataPoints.isNotEmpty) {
        final lastValue = dataPoints.last.value;
        return _convertToDouble(lastValue);
      }
    } else {
      print("Authorization not granted for $dataType data.");
    }
    return null;
  }

  static double? _convertToDouble(dynamic value) {
    // Check if the value is a NumericHealthValue and convert accordingly
    if (value is NumericHealthValue) {
      // Access the numericValue property, which is of type num, and convert it to double
      return value.numericValue.toDouble();
    }
    // return the value if it is already a double
    else if (value is double) {
      return value;
    }
    else if (value is int) {
      return value.toDouble();
    }
    else if (value is String) {
      return double.tryParse(value);
    }
    else {
      print("Unable to convert the value to double: $value");
      return null;
    }
  }

  static bool shouldUploadBMI() {
    if (lastFetchedDate == null) return true;
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    return lastFetchedDate!.isBefore(startOfToday);
  }
}
