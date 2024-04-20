import 'package:flutter/material.dart';

class IfDeclinedScreen extends StatelessWidget {
  static const String routeName = '/ifDeclined';

  const IfDeclinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Declined"),
      ),
      body: const Center(
        child: Text(
          "You declined the project. Please ask the admin for a new project.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
