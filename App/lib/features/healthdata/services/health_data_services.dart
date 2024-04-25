import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/error_handling.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/models/health_data.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/constants/utilities.dart';

class HealthDataService {
    // For testing purposes
  final http.Client client;

  HealthDataService({http.Client? client})
    : this.client = client ?? HealthDataService.createDefaultClient();

  static http.Client createDefaultClient() {
    return http.Client();
  }
  // Post single health data to the backend.
  Future<void> postSingleHealthData({
    required BuildContext context,
    required HealthData healthData,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/users/$userId/healthData"),
        body: jsonEncode(healthData.toMap()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar2(context, '${healthData.type} data for ${healthData.date} uploaded successfully');
        },
      );
    } catch (e) {
      showSnackBar2(context, 'Error uploading ${healthData.type} data: ${e.toString()}');
    }
  }

  // Post bulk health data to the backend.
  Future<void> postBulkHealthData({
    required BuildContext context,
    required List<HealthData> healthDataPoints,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/users/$userId/healthData/bulk"), 
        body: jsonEncode({'data': healthDataPoints.map((data) => data.toMap()).toList()}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar2(context, 'Bulk health data uploaded successfully');
        },
      );
    } catch (e) {
      showSnackBar2(context, 'Error uploading bulk health data: ${e.toString()}');
    }
  }

  // Upload health data using single or bulk based on the number of health data points.
  Future<void> uploadHealthData({
    required BuildContext context,
    required List<HealthData> healthDataPoints,
  }) async {
    if (healthDataPoints.length == 1) {
      await postSingleHealthData(context: context, healthData: healthDataPoints.first);
    } else if (healthDataPoints.length > 1) {
      await postBulkHealthData(context: context, healthDataPoints: healthDataPoints);
    }
  }
}

