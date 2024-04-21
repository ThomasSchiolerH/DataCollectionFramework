import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/error_handling.dart';
import 'package:mental_health_app/constants/utilities.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AnalyseServices {
  static Future<String> fetchAnalysis(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/users/$userId/analyseStepsMoodWeekly"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {},
      );

      final data = json.decode(res.body);
      return data['feedback'] ??
          "Analysis completed, but no feedback was provided.";
    } catch (e) {
      showSnackBar2(context, 'Error fetching analysis: ${e.toString()}',
          isError: true);
      return "Failed to fetch analysis. Please try again later.";
    }
  }

  static Future<List<dynamic>> fetchMoodAnalysis(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    try {
      final response = await http.get(
        Uri.parse("$uri/api/users/$userId/avgHealthData"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['moodAnalysis'] ?? []; 
      } else {
        return [];
      }
    } catch (e) {
      showSnackBar2(context, 'Error fetching mood analysis: ${e.toString()}',
          isError: true);
      return [];
    }
  }
}
