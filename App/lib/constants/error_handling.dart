import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/utilities.dart';

void httpErrorHandling({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar2(context, jsonDecode(response.body)['msg'], isError: true);
      break;
    case 500:
      showSnackBar2(context, jsonDecode(response.body)['error'], isError: true);
      break;
    default:
    showSnackBar2(context, response.body, isError: true);
  }
}
