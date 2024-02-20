import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void showSnackBar2(BuildContext context, String text, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: isError
          ? Colors.red
          : Colors.green, // Change color based on error status
      behavior: SnackBarBehavior.floating, // Optional: Makes snackbar floating
      duration: const Duration(seconds: 3), // Duration can be adjusted
    ),
  );
}
