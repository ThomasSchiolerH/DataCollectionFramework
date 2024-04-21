import 'package:flutter/material.dart';
import 'package:mental_health_app/features/auth/screens/auth_screen.dart';
import 'package:mental_health_app/features/healthdata/screens/healthdata_screen.dart';
import 'package:mental_health_app/features/heatmap/screens/heatmap_screen.dart';
import 'package:mental_health_app/features/analyze/screens/analyze_screen.dart';
import 'package:mental_health_app/features/user_input/screens/user_input_data_screen.dart';
import 'package:mental_health_app/features/project/screens/accept_decline_project.dart';
import 'package:mental_health_app/features/project/screens/no_project_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        case IfDeclinedScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const IfDeclinedScreen(),
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
