import 'package:flutter/material.dart';
import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/testScreen.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch(routeSettings.name) {
    case testScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const testScreen(),
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