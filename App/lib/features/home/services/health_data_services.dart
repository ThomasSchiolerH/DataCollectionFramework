import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/error_handle.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/models/health_data.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/constants/utilities.dart';

class HealthDataService {
  // Post health data
  void postHealthData({
    required BuildContext context,
    required String type,
    required num value,
    required String unit,
    required DateTime date,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user.id;

      HealthData healthData = HealthData(
        type: type,
        value: value,
        unit: unit,
        date: date,
      );

      http.Response res = await http.post(
        Uri.parse("$uri/api/users/$userId/healthData"),
        body: jsonEncode(healthData.toMap()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${userProvider.user.token}', // Pass the token for authentication
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar2(context, '$type data uploaded successfully');
        },
      );
    } catch (e) {
      showSnackBar2(context, 'Error uploading $type data: ${e.toString()}',
          isError: true);
    }
  }
}
