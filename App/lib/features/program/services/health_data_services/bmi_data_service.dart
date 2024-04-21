import 'package:health/health.dart';

class BMIDataService {
  static final HealthFactory health = HealthFactory();
  static DateTime? lastFetchedDate;

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
    if (value is NumericHealthValue) {
      return value.numericValue.toDouble();
    }
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
