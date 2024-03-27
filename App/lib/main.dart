import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/features/auth/screens/auth_screen.dart';
import 'package:mental_health_app/features/home/services/notification_services.dart';
import 'package:mental_health_app/provider/health_data_providers/bmi_provider.dart';
import 'package:mental_health_app/provider/health_data_providers/exercise_time_provider.dart';
import 'package:mental_health_app/provider/health_data_providers/heart_rate_provider.dart';
import 'package:mental_health_app/provider/health_data_providers/step_provider.dart';
import 'package:mental_health_app/provider/user_input_providers/mood_provider.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:mental_health_app/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => StepProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ExerciseTimeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => BMIProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MoodProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => HeartRateProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Health App',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const AuthScreen(),
    );
  }
}
