import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../healthdata/screens/healthdata_screen.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:mental_health_app/provider/user_input_data_provider/user_input_data_provider.dart';

class MoodScreen extends StatefulWidget {
  static const String routeName = "/mood";

  const MoodScreen({super.key});

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  bool _isLoading = true;
  String? _customUserMessage;
  int? _lowestValue;
  int? _highestValue;
  String? _inputType;

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

  // Fetches the custom user message from the backend
  Future<void> _fetchCustomUserMessage() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user.id;

    try {
      final response = await http.get(
        Uri.parse('$uri/api/users/$userId/project'),
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
        String? inputType = data['inputType'];

        setState(() {
          _customUserMessage = message;
          _lowestValue = lowestValue ?? 1;
          _highestValue = highestValue ?? 6;
          _inputType = inputType;
        });
      } else {
        print('Error fetching custom user message: ${response.body}');
      }
    } catch (e) {
      print('Exception caught during fetch: $e');
    }
  }

  // Checks if the user has already given input for today
  Future<void> _checkUserInputForToday() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user.id;
    final String currentDateFormatted =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Input Data"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, HomeScreen.routeName),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _customUserMessage ??
                  'There are not given anything to answer for you today',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: (_highestValue != null && _lowestValue != null)
                    ? (_highestValue! - _lowestValue! + 1)
                    : 0,
                itemBuilder: (context, index) {
                  int moodValue = _lowestValue! + index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: _getColorForMood(
                                moodValue, _lowestValue!, _highestValue!),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(4000, 40),
                          ),
                          onPressed: () =>
                              _selectMoodAndNavigate(context, moodValue),
                          child: Text('$moodValue'),
                        ),
                      ),
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
    const Color startColor = Color.fromRGBO(180, 180, 180, 1);
    const Color endColor = Color.fromRGBO(70, 220, 83, 1);
    double ratio =
        (mood - lowestValue) / (highestValue - lowestValue).toDouble();
    int r = startColor.red + ((endColor.red - startColor.red) * ratio).round();
    int g = startColor.green +
        ((endColor.green - startColor.green) * ratio).round();
    int b =
        startColor.blue + ((endColor.blue - startColor.blue) * ratio).round();
    return Color.fromRGBO(r, g, b, 1);
  }

  void _selectMoodAndNavigate(BuildContext context, int moodValue) async {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    if (_inputType == null || _inputType!.isEmpty) {
      print("Input type is not specified.");
      return;
    }
    moodProvider.setMoodValue(moodValue);
    await moodProvider.postUserInput(context, _inputType!);
    Navigator.pushReplacementNamed(context, '/home');
  }
}
