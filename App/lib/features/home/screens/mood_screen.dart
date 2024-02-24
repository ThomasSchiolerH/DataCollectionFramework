import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoodScreen extends StatefulWidget {
  static const String routeName = "/mood";
  const MoodScreen({Key? key}) : super(key: key);

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    _currentDate = formatter.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How are you feeling today? Select a mood for $_currentDate:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8, // Horizontal space between buttons
              alignment: WrapAlignment.center,
              children: List.generate(6, (index) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button color
                  onPrimary: Colors.white, // Text color
                ),
                onPressed: () => _selectMoodAndNavigate(context, index + 1),
                child: Text('${index + 1}'),
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _selectMoodAndNavigate(BuildContext context, int moodValue) {
    // Here, you might want to do something with the selected moodValue before navigating
    Navigator.pushReplacementNamed(context, '/home');
    // You can also pass moodValue to the next screen if needed
  }
}
