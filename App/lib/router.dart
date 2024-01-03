import 'package:flutter/material.dart';
import 'package:mental_health_app/features/auth/screens/auth_screen.dart';
import 'package:mental_health_app/main.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch(routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist - error!'),
          ),
        ),
      );
  }
}