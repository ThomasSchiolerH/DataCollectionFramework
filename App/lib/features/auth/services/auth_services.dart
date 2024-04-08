import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/error_handle.dart';
import 'package:mental_health_app/constants/utilities.dart';
import 'package:mental_health_app/features/auth/screens/auth_screen.dart';
import 'package:mental_health_app/features/home/screens/mood_screen.dart';
import 'package:mental_health_app/models/user.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AuthServices {
  // Updated sign up method with navigation to AcceptProjectScreen
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
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/acceptProject', // Use the route name for AcceptProjectScreen
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Updated sign in method with navigation to AcceptProjectScreen
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
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/acceptProject', // Use the route name for AcceptProjectScreen
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
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
