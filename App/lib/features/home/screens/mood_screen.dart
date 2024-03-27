import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/provider/user_input_providers/mood_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home_screen.dart';
import 'package:mental_health_app/provider/user_provider.dart';

class MoodScreen extends StatefulWidget {
  static const String routeName = "/mood";

  const MoodScreen({Key? key}) : super(key: key);

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String _currentDate = '';
  String _currentDateFormatted = '';
  bool _isLoading = true; // New loading state

  // Define a list of prefixes for each mood description
  List<String> moodPrefixes = [
    "terrible: ", // Prefix for mood 1
    "bad: ", // Prefix for mood 2
    "okay: ", // Prefix for mood 3
    "good: ", // Prefix for mood 4
    "very good: ", // Prefix for mood 5
    "excellent: " // Prefix for mood 6
  ];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _currentDate = now.toIso8601String();
    _currentDateFormatted = DateFormat('dd-MM-yyyy').format(now); // Used for display
    _checkUserInputForToday();
  }

void _checkUserInputForToday() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final String userId = userProvider.user.id;
  final String currentDateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());

  try {
    final response = await http.get(
      Uri.parse('$uri/api/users/$userId/hasInputForDate?date=$currentDateFormatted'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userProvider.user.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final bool hasInput = data['hasInput'];

      // Delay the navigation to HomeScreen by a short duration
      Future.delayed(const Duration(milliseconds: 500), () {
        if (hasInput) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        } else {
          // If user doesn't have input, set loading to false to show MoodScreen
          setState(() {
            _isLoading = false;
          });
        }
      });
    } else {
      print('Error checking user input: ${response.body}');
    }
  } catch (e) {
    print('Exception caught during API call: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show loader while checking user input
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Show MoodScreen only when loading is false
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 20), // Top margin of 20px
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start, // Align items to the left
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
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
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(6, (index) {
                    Color buttonColor = _getColorForMood(index + 1);
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0), // Space between buttons
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: buttonColor, // Text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10), // Button padding
                        ),
                        onPressed: () =>
                            _selectMoodAndNavigate(context, index + 1),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // To keep the Row content as compact as possible
                          children: [
                            Text(
                              "${moodPrefixes[index]}${index + 1}", // Use the prefix for each button
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, // Make the text bold
                              ),
                            ),
                          ],
                        ),
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
  }

  Color _getColorForMood(int mood) {
    const List<Color> moodColors = [
      Color.fromRGBO(155, 155, 155, 1), //1
      Color.fromRGBO(175, 175, 175, 1), //2
      Color.fromRGBO(195, 203, 195, 1), //3
      Color.fromRGBO(180, 230, 180, 1), //4
      Color.fromRGBO(160, 230, 160, 1), //5
      Color.fromRGBO(125, 238, 125, 1), //6
    ];
    return moodColors[mood - 1];
  }

  void _selectMoodAndNavigate(BuildContext context, int moodValue) async {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    moodProvider.setMoodValue(moodValue);

    // Post the user input
    await moodProvider.postUserInput(context);

    // Navigate to the home screen after uploading the mood
    Navigator.pushReplacementNamed(context, '/home');
  }
}
