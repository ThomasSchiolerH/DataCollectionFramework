import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/error_handle.dart';
import 'package:mental_health_app/constants/utilities.dart';
import 'package:mental_health_app/features/home/screens/home_screen.dart';
import 'package:mental_health_app/models/user.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/provider/user_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AuthServices {
  // sign up
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
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
      //TODO: Fix
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account has been created!',
          );
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
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
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print("test");
      print(res.body);
      //TODO: Fix
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () async {
          //SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          //await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }
}
