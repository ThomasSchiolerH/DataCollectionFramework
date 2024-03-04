import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/error_handle.dart';
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
          'Authorization': 'Bearer ${userProvider.user.token}', // Use the token for authentication
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {},
      );

      final data = json.decode(res.body);
      return data['feedback'] ?? "Analysis completed, but no feedback was provided.";
    } catch (e) {
      showSnackBar2(context, 'Error fetching analysis: ${e.toString()}',
          isError: true);
      return "Failed to fetch analysis. Please try again later.";
    }
  }
}
