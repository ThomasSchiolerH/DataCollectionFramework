import 'package:flutter/material.dart';
import 'package:mental_health_app/features/auth/screens/auth_screen.dart';
import 'package:mental_health_app/features/home/screens/home_screen.dart';
import 'package:mental_health_app/features/home/screens/calendar_screen.dart';
import 'package:mental_health_app/features/home/screens/analyze_screen.dart';
import 'package:mental_health_app/features/home/screens/mood_screen.dart';
import 'package:mental_health_app/features/home/screens/accept_decline_user_input_message.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: generateRoute,
    );
  }
}

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case AcceptProjectScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AcceptProjectScreen(),
      );
    case MoodScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MoodScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case CalendarScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CalendarScreen(),
      );
    case AnalyseScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AnalyseScreen(),
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
