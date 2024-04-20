import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/constants/utilities.dart';
import 'package:mental_health_app/features/auth/services/auth_services.dart';
import 'package:mental_health_app/provider/health_data_providers/bmi_provider.dart';
import 'package:mental_health_app/provider/health_data_providers/heart_rate_provider.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'heatmap_screen.dart';
import 'analyze_screen.dart';
import 'package:mental_health_app/provider/health_data_providers/step_provider.dart';
import 'package:mental_health_app/provider/health_data_providers/exercise_time_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this);
    checkConnectivityAndUploadData(); // check when the screen is first loaded
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove the observer
    super.dispose();
  }

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
    appBar: _selectedIndex == 0 ? AppBar( // Conditional rendering based on _selectedIndex
      title: Text('Welcome ${user.name}!'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => authServices.logoutUser(context),
          tooltip: 'Logout',
        ),
      ],
    ) : null,
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
      selectedItemColor: GlobalVariables.selectedNavBarColor,
      unselectedItemColor: GlobalVariables.unselectedNavBarColor,
      backgroundColor: Colors.white,
    ),
  );
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      checkConnectivityAndUploadData();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Adding a delay before checking connectivity and updating data
      Future.delayed(const Duration(seconds: 1), () {
        checkConnectivityAndUploadData();
      });
    }
  }

  void checkConnectivityAndUploadData() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.wifi) {
        await Provider.of<StepProvider>(context, listen: false)
            .fetchAndUploadSteps(context);
        await Provider.of<ExerciseTimeProvider>(context, listen: false)
            .fetchAndUploadExerciseTime(context);
        await Provider.of<BMIProvider>(context, listen: false)
            .fetchAndUploadBMI(context);
        await Provider.of<HeartRateProvider>(context, listen: false)
            .fetchAndUploadHeartRate(context);
      } else {
        showSnackBar2(context, 'Data will upload once connected to Wi-Fi.',
            isError: true);
      }
    } catch (e) {
      showSnackBar2(
          context, 'Failed to check network connectivity: ${e.toString()}',
          isError: true);
    }
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});
  @override
  HomeScreenContentState createState() => HomeScreenContentState();
}

class HomeScreenContentState extends State<HomeScreenContent> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to ensure provider methods are called after the build method
    Future.microtask(() => Provider.of<StepProvider>(context, listen: false)
        .fetchTotalStepsForToday());
    Future.microtask(() =>
        Provider.of<ExerciseTimeProvider>(context, listen: false)
            .fetchTotalExerciseTimeForToday());
    Future.microtask(() => Provider.of<BMIProvider>(context, listen: false)
        .fetchTotalBMIForToday());
    Future.microtask(() =>
        Provider.of<HeartRateProvider>(context, listen: false)
            .fetchTotalHeartRateForToday());
  }

  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);
    final exerciseTimeProvider = Provider.of<ExerciseTimeProvider>(context);
    final bmiProvider = Provider.of<BMIProvider>(context);
    final heartRateProvider = Provider.of<HeartRateProvider>(context);

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
                  return buildInfoCard('Total Steps', '${stepProvider.steps}');
                }
              },
            ),
            const SizedBox(height: 10),
            Consumer<HeartRateProvider>(
              builder: (context, heartRateProvider, child) {
                if (heartRateProvider.isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return buildInfoCard(
                      'Avg. Heart Rate', '${heartRateProvider.heart_rate}');
                }
              },
            ),
            const SizedBox(height: 10),
            Consumer<ExerciseTimeProvider>(
              builder: (context, exerciseTimeProvider, child) {
                return exerciseTimeProvider.isLoading
                    ? const CircularProgressIndicator()
                    : buildInfoCard('Total Exercise Time',
                        '${exerciseTimeProvider.totalExerciseTime} minutes');
              },
            ),
            const SizedBox(height: 10),
            Consumer<BMIProvider>(
              builder: (context, bmiProvider, child) {
                var bmiValue = bmiProvider.bmi;
                return bmiValue == null
                    ? const CircularProgressIndicator()
                    : buildInfoCard(
                        'Current BMI',
                        bmiValue.toStringAsFixed(
                            2));
              },
            ),
            // ElevatedButton(
            //   onPressed: () => NotificationService.showNotification(
            //       id: 0, title: "Test", body: "It works"),
            //   child: const Text('Notification'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Card(
      color: Colors.white,
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
