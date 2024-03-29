import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:mental_health_app/provider/user_input_providers/mood_provider.dart';

class MoodScreen extends StatefulWidget {
  static const String routeName = "/mood";

  const MoodScreen({Key? key}) : super(key: key);

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  bool _isLoading = true;
  String? _customUserMessage;
  int? _lowestValue;
  int? _highestValue;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await Future.wait([
      _fetchCustomUserMessage(),
      _checkUserInputForToday(),
    ]);
    await Future.delayed(const Duration(seconds: 1)); 
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchCustomUserMessage() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user.id;

  try {
    final response = await http.get(
      Uri.parse('$uri/api/users/$userId/userInputMessage'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userProvider.user.token}',
      },
    );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String? message = data['message'];
        int? lowestValue = data['lowestValue'];
        int? highestValue = data['highestValue'];

        setState(() {
          _customUserMessage = message;
          _lowestValue = lowestValue ?? 1;
          _highestValue = highestValue ?? 6;
        });
      } else {
        print('Error fetching custom user message: ${response.body}');
      }
    } catch (e) {
      print('Exception caught during fetch: $e');
    }
  }

  Future<void> _checkUserInputForToday() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user.id;
    final String currentDateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final response = await http.get(
        Uri.parse(
            '$uri/api/users/$userId/hasInputForDate?date=$currentDateFormatted'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final bool hasInput = data['hasInput'] as bool;
        if (hasInput) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
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
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen.routeName),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _customUserMessage ?? 'How are you feeling today?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: (_highestValue != null && _lowestValue != null) ? (_highestValue! - _lowestValue! + 1) : 0,
                itemBuilder: (context, index) {
                  int moodValue = _lowestValue! + index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: _getColorForMood(moodValue, _lowestValue!, _highestValue!),
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onPressed: () => _selectMoodAndNavigate(context, moodValue),
                      child: Text('$moodValue'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForMood(int mood, int lowestValue, int highestValue) {
    Color startColor = Color.fromRGBO(155, 155, 155, 1); 
    Color endColor = Color.fromRGBO(125, 238, 125, 1); 
    double ratio = (mood - lowestValue) / (highestValue - lowestValue).toDouble();
    int r = startColor.red + ((endColor.red - startColor.red) * ratio).round();
    int g = startColor.green + ((endColor.green - startColor.green) * ratio).round();
    int b = startColor.blue + ((endColor.blue - startColor.blue) * ratio).round();
    return Color.fromRGBO(r, g, b, 1);
  }

  void _selectMoodAndNavigate(BuildContext context, int moodValue) async {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    moodProvider.setMoodValue(moodValue);
    await moodProvider.postUserInput(context);
    Navigator.pushReplacementNamed(context, '/home');
  }
}
