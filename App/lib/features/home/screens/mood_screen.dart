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
              runSpacing: 8, // Vertical space between buttons
              alignment: WrapAlignment.center,
              children: List.generate(6, (index) {
                // Calculate color based on index
                Color buttonColor = _getColorForMood(index + 1);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: buttonColor, // Use the calculated color
                    onPrimary: Colors.white, // Text color
                    minimumSize: Size(40, 36), // Set the minimum button size (width, height)
                  ),
                  onPressed: () => _selectMoodAndNavigate(context, index + 1),
                  child: Text('${index + 1}'),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForMood(int mood) {
    // Define your color scale from grey to green
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
