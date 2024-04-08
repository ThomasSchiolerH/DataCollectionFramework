import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/screens/home_screen.dart';
import 'package:mental_health_app/features/home/screens/mood_screen.dart';

class AcceptProjectScreen extends StatefulWidget {
  static const String routeName = '/acceptProject';

  const AcceptProjectScreen({Key? key}) : super(key: key);

  @override
  _AcceptProjectScreenState createState() => _AcceptProjectScreenState();
}

class _AcceptProjectScreenState extends State<AcceptProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accept Project'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, MoodScreen.routeName),
              child: const Text('Accept'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen.routeName),
              child: const Text('Decline'),
            ),
          ],
        ),
      ),
    );
  }
}
