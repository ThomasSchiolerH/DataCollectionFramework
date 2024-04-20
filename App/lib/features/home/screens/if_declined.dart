import 'package:flutter/material.dart';
import 'package:mental_health_app/features/auth/screens/auth_screen.dart';

class IfDeclinedScreen extends StatelessWidget {
  static const String routeName = '/ifDeclined';

  const IfDeclinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("No Available Projects"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AuthScreen.routeName);
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20), 
          margin: const EdgeInsets.all(20), 
          decoration: BoxDecoration(
            color: Colors.grey[200], 
            borderRadius: BorderRadius.circular(10), 
            border: Border.all(
              color: Colors.grey[400]!, 
              width: 1, 
            ),
          ),
          child: Text(
            "You don't have any projects at the moment. Please ask an admin for a new project, if you want to gain access.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black, 
            ),
          ),
        ),
      ),
    );
  }
}
