import 'package:flutter/material.dart';
import 'package:mental_health_app/features/auth/services/auth_services.dart';

class IfDeclinedScreen extends StatelessWidget {
  static const String routeName = '/ifDeclined';

  const IfDeclinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthServices authServices = AuthServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text("No Available Projects"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authServices.logoutUser(context);
            },
            tooltip: 'Logout', 
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "You don't have any projects at the moment. Please ask an admin for a new project, if you want to gain access.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
