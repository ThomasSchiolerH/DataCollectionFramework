// import 'package:flutter/material.dart';
// import 'package:mental_health_app/features/home/services/health_data_services/get_sleep.dart';
// import 'package:mental_health_app/features/home/services/health_data_services.dart';

// class SleepProvider with ChangeNotifier {
//   int _sleepMinutes = 0;
//   bool _isLoading = true;

//   int get sleepMinutes => _sleepMinutes;
//   bool get isLoading => _isLoading;

//   Future<void> fetchSleep() async {
//     _isLoading = true;
//     notifyListeners();

//     await GetSleepService.fetchSleepData();
//     _sleepMinutes = GetSleepService.getSleepMinutes;

//     // Handle error state or notify users as necessary
//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> uploadSleep(BuildContext context) async {
//     await fetchSleep();
//     // Confirming data to be uploaded
//     HealthDataService().postHealthData(
//       context: context,
//       type: 'sleep',
//       value: _sleepMinutes,
//       unit: 'minutes',
//       date: DateTime.now(),
//     );
//   }
// }
