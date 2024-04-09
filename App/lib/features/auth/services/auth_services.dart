import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/error_handle.dart';
import 'package:mental_health_app/constants/utilities.dart';
import 'package:mental_health_app/features/auth/screens/auth_screen.dart';
import 'package:mental_health_app/features/home/screens/accept_decline_user_input_message.dart';
import 'package:mental_health_app/features/home/screens/if_declined.dart';
import 'package:mental_health_app/features/home/screens/mood_screen.dart';
import 'package:mental_health_app/models/user.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AuthServices {
  // Sign up
  void signUpUser({
    required BuildContext context,
    required String name,
    required String age,
    required String gender,
    required String email,
    required String password,
  }) async {
    try {
      final int? ageInt = int.tryParse(age); // Convert age to an int
      if (ageInt == null) {
        showSnackBar2(context, 'Age must be a valid number.', isError: true);
        return;
      }
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        age: ageInt,
        gender: gender,
        type: '',
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse("$uri/api/signup"),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account has been created!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Sign in
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final String userToken = jsonDecode(res.body)['token'];
          await prefs.setString('auth-token', userToken);

          // setUser method now updates user with projectResponse
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          final String userId =
              Provider.of<UserProvider>(context, listen: false).user.id;
          final String? projectResponse =
              await fetchProjectResponse(context, userId);

          // Conditional navigation based on projectResponse
          switch (projectResponse) {
            case "Accepted":
              await Navigator.pushNamedAndRemoveUntil(
                  context, MoodScreen.routeName, (route) => false);
              break;
            case "Declined":
              await Navigator.pushNamedAndRemoveUntil(
                  context, IfDeclinedScreen.routeName, (route) => false);
              break;
            case null:
              await Navigator.pushNamedAndRemoveUntil(
                  context, AcceptProjectScreen.routeName, (route) => false);
              break;
            default:
              break;
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<String?> fetchProjectResponse(
      BuildContext context, String userId) async {
    try {
      final response = await http.get(
        Uri.parse("$uri/api/users/$userId/userInputMessage"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${await SharedPreferences.getInstance().then((prefs) => prefs.getString('auth-token'))}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['projectResponse'];
      } else {
        // Handle non-200 responses
        throw Exception('Failed to fetch project response');
      }
    } catch (e) {
      showSnackBar(context, 'Error fetching project response: ${e.toString()}');
      return null;
    }
  }

  void logoutUser(BuildContext context) async {
    try {
      // Clear the authentication token from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth-token');

      Provider.of<UserProvider>(context, listen: false).clearUser();

      Navigator.pushNamedAndRemoveUntil(
          context, AuthScreen.routeName, (route) => false);
    } catch (e) {
      showSnackBar(context, 'Error during logout: ${e.toString()}');
    }
  }
}
