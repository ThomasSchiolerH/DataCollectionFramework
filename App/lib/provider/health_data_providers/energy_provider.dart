import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_app/features/healthdata/services/sensor_services/energy_services.dart';
import 'package:mental_health_app/features/healthdata/services/health_data_services.dart';
import 'package:mental_health_app/models/health_data.dart';
import 'package:mental_health_app/features/user_input/services/user_input_services.dart';

class EnergyProvider with ChangeNotifier {
  bool _isLoading = true;
  int _energy = 0;

  bool get isLoading => _isLoading;
  int get energy => _energy;

  // Updates the last upload date in the shared preferences
  Future<void> _updateLastUploadDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastEnergyUploadDate', date.toIso8601String());
  }

  // Fetches the last upload date from the shared preferences
  Future<DateTime> _getLastUploadDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastUploadDateString = prefs.getString('lastEnergyUploadDate');
    if (lastUploadDateString == null) {
      return DateTime.now()
          .subtract(const Duration(days: 1)); 
    }
    return DateTime.parse(lastUploadDateString);
  }

  // Fetches the energy data and uploads it
  Future<void> fetchAndUploadEnergy(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    UserInputService userInputService = UserInputService();

    final Map<String, bool> enabledSensors =
        await userInputService.fetchUserSettings(context);

    if (enabledSensors['active_energy_burned'] ?? false) {
      DateTime lastUploadDate = await _getLastUploadDate();
      DateTime now = DateTime.now();
      DateTime startOfCurrentHour =
          DateTime(now.year, now.month, now.day, now.hour);
      print("Fetching and uploading energy data...");

      List<HealthData> hourlyEnergy = await GetEnergyService.fetchHourlyEnergyData(
          lastUploadDate, startOfCurrentHour);
      if (hourlyEnergy.isNotEmpty) {
        _energy = hourlyEnergy.fold(0, (sum, data) => sum + data.value.toInt());

        HealthDataService().uploadHealthData(
          context: context,
          healthDataPoints: hourlyEnergy,
        );
        await _updateLastUploadDate(now);
        print("Fetched ${hourlyEnergy.length} hourly data points.");
      }
    } else {
      print("Energy data upload is disabled by admin.");
    }

    await GetEnergyService.fetchTotalEnergyForToday();
    _isLoading = false;
    notifyListeners();
  }

  // Fetches the total energy for today
  Future<void> fetchTotalEnergyForToday() async {
    _energy = 0;
    await GetEnergyService.fetchTotalEnergyForToday();
    _energy = GetEnergyService
        .totalEnergyForToday; 
    notifyListeners(); 
  }
}
