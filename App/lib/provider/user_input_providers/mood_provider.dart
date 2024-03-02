import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/utilities.dart'; // Ensure this path is correct
import 'package:mental_health_app/features/home/services/user_input_services.dart'; // Ensure this path is correct
import 'package:provider/provider.dart';

class MoodProvider with ChangeNotifier {
  int _moodValue = 0; // Default or initial mood value
  bool _isUploading = false;

  // Instantiating UserInputService directly within the MoodProvider class
  final UserInputService userInputService = UserInputService();

  int get moodValue => _moodValue;
  bool get isUploading => _isUploading;

  void setMoodValue(int newValue) {
    _moodValue = newValue;
    notifyListeners(); // Notify listeners about the change
  }

  Future<void> postUserInput(BuildContext context) async {
    if (_moodValue == 0) {
      // Handle the case where moodValue is not set or is the default value
      showSnackBar2(context, "Please select a mood before submitting.",
          isError: true);
      return;
    }

    _isUploading = true;
    notifyListeners(); // Notify listeners that the upload process has started

    // Assuming postUserInput in UserInputService is properly implemented as an async method
    await userInputService.postUserInput(
      context: context,
      type: "mood", // The type of input you're posting, e.g., "mood"
      value: _moodValue, // The mood value set by the user
      date: DateTime.now(), // The current date
    );
    _isUploading = false;
    notifyListeners(); // Notify that the upload process has ended
  }
}
