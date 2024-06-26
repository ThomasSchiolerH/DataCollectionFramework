import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/error_handling.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/models/user_input.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/constants/utilities.dart';

class UserInputService {
  // Post user input to the backend.
  Future<void> postUserInput({
    required BuildContext context,
    required String type,
    required num value,
    required DateTime date,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    UserInput userInput = UserInput(
      type: type,
      value: value,
      date: date,
    );

    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/users/$userId/userInput"),
        body: jsonEncode(userInput.toMap()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar2(context, 'User input uploaded successfully');
        },
      );
    } catch (e) {
      showSnackBar2(context, 'Error uploading user input: ${e.toString()}',
          isError: true);
    }
  }

  // Fetches enabled and disabled sensors for the project.
  Future<Map<String, bool>> fetchUserSettings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;
    Map<String, bool> enabledSensors = {};

    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/users/$userId/project"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          final data = json.decode(res.body);
          if (data['enabledSensors'] != null) {
            enabledSensors = Map<String, bool>.from(data['enabledSensors']);
          }
        },
      );
    } catch (e) {
      showSnackBar2(context, 'Error fetching user settings: ${e.toString()}',
          isError: true);
    }

    return enabledSensors;
  }
}
