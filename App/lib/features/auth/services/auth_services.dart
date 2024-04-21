import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/error_handling.dart';
import 'package:mental_health_app/constants/utilities.dart';
import 'package:mental_health_app/features/auth/screens/auth_screen.dart';
import 'package:mental_health_app/features/project/screens/accept_decline_project.dart';
import 'package:mental_health_app/features/project/screens/no_project_screen.dart';
import 'package:mental_health_app/features/user_input/screens/user_input_data_screen.dart';
import 'package:mental_health_app/models/user.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AuthServices {
  // SignUp
  void signUpUser({
    required BuildContext context,
    required String name,
    required String age,
    required String gender,
    required String email,
    required String password,
  }) async {
    try {
      final int? ageInt = int.tryParse(age);
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

  // SignIn
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final Uri signInUri = Uri.parse("$uri/api/signin");
      final response = await http.post(
        signInUri,
        body: jsonEncode({"email": email, "password": password}),
        headers: {'Content-Type': 'application/json'},
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth-token', body['token']);

        Provider.of<UserProvider>(context, listen: false)
            .setUser(response.body);
        navigateBasedOnProjectResponse(context);
      } else {
        throw Exception('Failed to sign in. Please check your credentials.');
      }
    } catch (e) {
      showSnackBar(context, 'Error signing in: ${e.toString()}');
    }
  }

  // Navigate to the correct screen based on project response
  void navigateBasedOnProjectResponse(BuildContext context) async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).user.id;
      final projectResponse = await fetchProjectResponse(context, userId);
      switch (projectResponse) {
        case 'Accepted':
          Navigator.pushReplacementNamed(context, MoodScreen.routeName);
          break;
        case 'Declined':
          Navigator.pushReplacementNamed(context, IfDeclinedScreen.routeName);
          break;
        case 'NotAnswered':
          Navigator.pushReplacementNamed(
              context, AcceptProjectScreen.routeName);
          break;
        case null:
          Navigator.pushReplacementNamed(context, IfDeclinedScreen.routeName);
          break;
        default:
          Navigator.pushReplacementNamed(context, AuthScreen.routeName);
          break;
      }
    } catch (e) {
      showSnackBar(context, 'Navigation error: ${e.toString()}');
    }
  }

  // Fetches project response
  Future<String?> fetchProjectResponse(
      BuildContext context, String userId) async {
    try {
      final response = await http.get(
        Uri.parse("$uri/api/users/$userId/project"),
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
        throw Exception('Failed to fetch project response');
      }
    } catch (e) {
      showSnackBar(context, 'Error fetching project response: ${e.toString()}');
      return null;
    }
  }

  //LogOut
  void logoutUser(BuildContext context) async {
    try {
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
