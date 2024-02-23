import 'package:flutter/material.dart';
import 'package:mental_health_app/provider/bmi_provider.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'calendar_screen.dart';
import 'package:mental_health_app/features/home/services/get_steps.dart';
import 'package:mental_health_app/provider/step_provider.dart';
import 'package:mental_health_app/provider/exercise_time_provider.dart';
import 'package:mental_health_app/provider/sleep_provider.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.name}!'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
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
    Future.microtask(
        () => Provider.of<StepProvider>(context, listen: false).fetchSteps());
    Future.microtask(() =>
        Provider.of<ExerciseTimeProvider>(context, listen: false)
            .fetchExerciseTime());
    Future.microtask(
        () => Provider.of<SleepProvider>(context, listen: false).fetchSleep());
    Future.microtask(
        () => Provider.of<BMIProvider>(context, listen: false).fetchBMI());
  }

  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);
    final exerciseTimeProvider = Provider.of<ExerciseTimeProvider>(context);
    final sleepProvider = Provider.of<SleepProvider>(context);
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
                        '${exerciseTimeProvider.exerciseTimeInMinutes} minutes');
              },
            ),
            const SizedBox(height: 10),
            Consumer<SleepProvider>(
              builder: (context, sleepProvider, child) {
                if (sleepProvider.isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return buildInfoCard(
                      'Sleep', '${sleepProvider.sleepMinutes} minutes');
                }
              },
            ),
            const SizedBox(height: 10),
            Consumer<BMIProvider>(
              builder: (context, bmiProvider, child) {
                // This assumes your BMIProvider correctly updates _bmi upon fetching.
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
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Provider.of<StepProvider>(context, listen: false)
                        .uploadSteps(context);
                    await Provider.of<ExerciseTimeProvider>(context,
                            listen: false)
                        .uploadExerciseTime(context);
                    await Provider.of<SleepProvider>(context, listen: false)
                        .uploadSleep(context);
                    await Provider.of<BMIProvider>(context, listen: false)
                        .uploadBMI(context);
                  },
                  child: const Text('Upload Data'),
                ),
              ),
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
