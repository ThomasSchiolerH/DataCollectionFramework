import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/error_handle.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/models/user_input.dart'; // Assuming you have a similar model for user input
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/constants/utilities.dart';

class UserInputService {

  // Post user input data
  Future<void> postUserInput({
    required BuildContext context,
    required String type,
    required num value,
    required DateTime date,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user.id;

      UserInput userInput = UserInput(
        type: type,
        value: value,
        date: date,
      );

      http.Response res = await http.post(
        Uri.parse("$uri/api/users/$userId/userInput"),
        body: jsonEncode(userInput.toMap()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}', // Pass the token for authentication
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
}
