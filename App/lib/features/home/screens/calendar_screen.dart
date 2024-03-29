import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/provider/user_provider.dart';

class CalendarScreen extends StatefulWidget {
  static const String routeName = "/calendar";

  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  Map<DateTime, int> datasets = {};
  bool _isLoading = true;
  int? _lowestValue;
  int? _highestValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserInputs();
    });
  }

  Future<void> _fetchUserInputs() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user.id;

    try {
      final response = await http.get(
        Uri.parse('$uri/api/users/$userId/moodInputs'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Fetched mood inputs data: $data");

        final List<dynamic>? inputs = data['moodInputs'] as List<dynamic>?;
        final Map<DateTime, int> newDatasets = {};

        int? lowestValue;
        int? highestValue;

        if (inputs != null) {
          for (var input in inputs) {
            if (input['type'] == 'mood') {
              final DateTime? date = DateTime.tryParse(input['date']);
              final int? value = int.tryParse(input['value'].toString());

              if (date != null && value != null) {
                // Ensure the date is in the correct format without the time part
                final DateTime dateWithoutTime =
                    DateTime(date.year, date.month, date.day);
                newDatasets[dateWithoutTime] = value;
              } else {
                print("Failed to parse date or value for input: $input");
              }
            } else if (input['type'] == 'userInputMessage') {
              lowestValue = input['lowestValue'] != null
                  ? int.tryParse(input['lowestValue'].toString())
                  : null;
              highestValue = input['highestValue'] != null
                  ? int.tryParse(input['highestValue'].toString())
                  : null;
            }
          }
        }

        setState(() {
          datasets = newDatasets;
          _isLoading = false;
          _lowestValue = lowestValue;
          _highestValue = highestValue;
        });
      } else {
        print(
            'Failed to fetch mood inputs with status code ${response.statusCode}: ${response.body}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Exception caught while fetching mood inputs: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar View'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar View'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildHeatMap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeatMap() {
    int? lowestMoodValue;
    int? highestMoodValue;
    datasets.values.forEach((value) {
      if (lowestMoodValue == null || value < lowestMoodValue!) {
        lowestMoodValue = value;
      }
      if (highestMoodValue == null || value > highestMoodValue!) {
        highestMoodValue = value;
      }
    });

    Color defaultStartColor = const Color.fromARGB(255, 255, 255, 255);
    Color defaultEndColor = const Color.fromARGB(255, 255, 0, 0);

    Map<int, Color> colorsets = {};
    if (lowestMoodValue != null && highestMoodValue != null) {
      for (int mood = lowestMoodValue!; mood <= highestMoodValue!; mood++) {
        Color color =
            _getColorForMood(mood, _lowestValue ?? 1, _highestValue ?? 6);
        colorsets[mood] = color;
      }
    } else {
      for (int mood = 1; mood <= 6; mood++) {
        colorsets[mood] = _getColorForMood(mood, 1, 6);
      }
    }

    return HeatMap(
      datasets: datasets,
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      colorsets: colorsets.isNotEmpty
          ? colorsets
          : {1: defaultStartColor, 6: defaultEndColor},
      onClick: (DateTime date) {
        // Here we look up the mood for the clicked date
        final mood = datasets[date];
        if (mood != null) {
          // If we have a mood for that date, show it in a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Your mood on ${formatter.format(date)} was "$mood"')),
          );
        } else {
          // If we don't have a mood for that date, you might want to handle it differently
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('No mood data for ${formatter.format(date)}')),
          );
        }
      },
    );
  }

Color _getColorForMood(int mood, int lowestValue, int highestValue) {
  Color startColor = const Color.fromARGB(255, 255, 255, 255); 
  Color endColor = const Color.fromARGB(255, 255, 45, 30); 
  double ratio = (mood - lowestValue) / (highestValue - lowestValue).toDouble();
  int r = startColor.red + ((endColor.red - startColor.red) * ratio).round();
  int g = startColor.green + ((endColor.green - startColor.green) * ratio).round();
  int b = startColor.blue + ((endColor.blue - startColor.blue) * ratio).round();
  return Color.fromRGBO(r, g, b, 1);
}
}
