import 'package:flutter/material.dart';
import 'package:mental_health_app/features/auth/services/auth_services.dart';
import 'package:mental_health_app/features/home/services/notification_services.dart';
import 'package:mental_health_app/provider/health_data_providers/bmi_provider.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'calendar_screen.dart';
import 'analyze_screen.dart';
import 'package:mental_health_app/provider/health_data_providers/step_provider.dart';
import 'package:mental_health_app/provider/health_data_providers/exercise_time_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreenContent(),
    CalendarScreen(),
    AnalyseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final AuthServices authServices = AuthServices();
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.name}!'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            onPressed: () =>
                authServices.logoutUser(context), // Call logout method
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analyse',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);
  @override
  HomeScreenContentState createState() => HomeScreenContentState();
}

class HomeScreenContentState extends State<HomeScreenContent> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to ensure fetchSteps is called after the build method
    Future.microtask(() => Provider.of<StepProvider>(context, listen: false)
        .fetchTotalStepsForToday());
    Future.microtask(() =>
        Provider.of<ExerciseTimeProvider>(context, listen: false)
            .fetchTotalExerciseTimeForToday());
    Future.microtask(() => Provider.of<BMIProvider>(context, listen: false)
        .fetchTotalBMIForToday());
  }

  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);
    final exerciseTimeProvider = Provider.of<ExerciseTimeProvider>(context);
    final bmiProvider = Provider.of<BMIProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Here is your overview for today!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Consumer<StepProvider>(
              builder: (context, stepProvider, child) {
                if (stepProvider.isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return buildInfoCard('Steps', '${stepProvider.steps}');
                }
              },
            ),
            const SizedBox(height: 10),
            Consumer<ExerciseTimeProvider>(
              builder: (context, exerciseTimeProvider, child) {
                return exerciseTimeProvider.isLoading
                    ? const CircularProgressIndicator()
                    : buildInfoCard('Exercise Time',
                        '${exerciseTimeProvider.totalExerciseTime} minutes');
              },
            ),
            const SizedBox(height: 10),
            Consumer<BMIProvider>(
              builder: (context, bmiProvider, child) {
                // Check if BMI is still loading, then display a progress indicator or the BMI value.
                var bmiValue = bmiProvider.bmi;
                return bmiValue == null
                    ? const CircularProgressIndicator()
                    : buildInfoCard(
                        'BMI',
                        bmiValue.toStringAsFixed(
                            2)); // Format BMI to 2 decimal places
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 40.0),
            //   child: Center(
            //     child: ElevatedButton(
            //       onPressed: () async {
            //         await Provider.of<StepProvider>(context, listen: false)
            //             .fetchAndUploadSteps(context);
            //         await Provider.of<ExerciseTimeProvider>(context,
            //                 listen: false)
            //             .fetchAndUploadExerciseTime(context);
            //         await Provider.of<SleepProvider>(context, listen: false)
            //             .uploadSleep(context);
            //         await Provider.of<BMIProvider>(context, listen: false)
            //             .fetchAndUploadBMI(context);
            //       },
            //       child: const Text('Upload Data'),
            //     ),
            //   ),
            // )
            ElevatedButton(
              onPressed: () => NotificationService.showNotification(
                  id: 0, title: "Test", body: "It works"),
              child: Text('Notification'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}