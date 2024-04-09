import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/utilities.dart'; 
import 'package:mental_health_app/features/home/services/user_input_services.dart'; 

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

  Future<void> postUserInput(BuildContext context, String inputType) async {
    if (_moodValue == 0) {
      showSnackBar2(context, "Please select a mood before submitting.",
          isError: true);
      return;
    }

    _isUploading = true;
    notifyListeners();

    await userInputService.postUserInput(
      context: context,
      type: inputType,
      value: _moodValue,
      date: DateTime.now(),
    );

    _isUploading = false;
    notifyListeners();
  }
}
