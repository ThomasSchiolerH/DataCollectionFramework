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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 20), // Top margin of 20px and left margin of 20px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 22, // Increased font size
                      fontWeight: FontWeight.bold, // Bold font weight
                      color: Colors.black, // Adjusted text color
                    ),
                  ),
                ),
                Text(
                  'Select a mood for $_currentDate:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ...List.generate(6, (index) {
                  List<String> moodDescriptions = [
                    "Not good (1)",
                    "Could be better (2)",
                    "Okay (3)",
                    "Good (4)",
                    "Very good (5)",
                    "Great (6)"
                  ];
                  Color buttonColor = _getColorForMood(index + 1);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Space between buttons
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: buttonColor, // Button background color
                        onPrimary: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
                      ),
                      onPressed: () => _selectMoodAndNavigate(context, index + 1),
                      child: Text(moodDescriptions[index]),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForMood(int mood) {
    List<Color> moodColors = [
      Colors.grey.shade500, // Mood 1
      Colors.grey.shade400, // Mood 2
      Colors.grey.shade300, // Mood 3
      Colors.lightGreen.shade200, // Mood 4
      Colors.lightGreen.shade300, // Mood 5
      Colors.green.shade400, // Mood 6
    ];
    return moodColors[mood - 1];
  }

  void _selectMoodAndNavigate(BuildContext context, int moodValue) {
    // Here, you might want to do something with the selected moodValue before navigating
    Navigator.pushReplacementNamed(context, '/home');
    // You can also pass moodValue to the next screen if needed
  }
}
