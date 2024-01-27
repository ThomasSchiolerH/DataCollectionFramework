import 'package:flutter/material.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'calendar_screen.dart';
import 'package:mental_health_app/features/home/services/get_steps.dart';
import 'package:mental_health_app/provider/step_provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);
    String screenTime = '2h 30m'; // Example screen time
    String socialMediaTime = '1h 15m'; // Example social media time

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
            buildInfoCard('Screen Time', screenTime),
            const SizedBox(height: 10),
            buildInfoCard('Social Media', socialMediaTime),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<StepProvider>(context, listen: false)
                    .uploadSteps(context);
              },
              child: const Text('Upload Data'),
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
