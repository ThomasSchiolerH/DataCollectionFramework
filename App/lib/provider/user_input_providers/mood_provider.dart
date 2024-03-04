import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/utilities.dart'; // Ensure this path is correct
import 'package:mental_health_app/features/home/services/user_input_services.dart'; // Ensure this path is correct

class MoodProvider with ChangeNotifier {
  int _moodValue = 0; 
  bool _isUploading = false;

  final UserInputService userInputService = UserInputService();

  int get moodValue => _moodValue;
  bool get isUploading => _isUploading;

  void setMoodValue(int newValue) {
    _moodValue = newValue;
    notifyListeners(); 
  }

  Future<void> postUserInput(BuildContext context) async {
    if (_moodValue == 0) {
      showSnackBar2(context, "Please select a mood before submitting.",
          isError: true);
      return;
    }

    _isUploading = true;
    notifyListeners();

    await userInputService.postUserInput(
      context: context,
      type: "mood", 
      value: _moodValue, 
      date: DateTime.now(),
    );
    _isUploading = false;
    notifyListeners(); 
  }
}
