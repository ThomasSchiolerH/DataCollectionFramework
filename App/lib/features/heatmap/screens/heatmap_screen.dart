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

  const CalendarScreen({super.key});

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

  // Fetches user inputs from the backend and updates the state
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
                final DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);
                newDatasets[dateWithoutTime] = value;
                lowestValue = lowestValue == null || value < lowestValue ? value : lowestValue;
                highestValue = highestValue == null || value > highestValue ? value : highestValue;
              }
            }
          }
        }

        setState(() {
          datasets = newDatasets;
          _lowestValue = lowestValue;
          _highestValue = highestValue;
          _isLoading = false;
        });
      } else {
        print('Failed to fetch mood inputs with status code ${response.statusCode}: ${response.body}');
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(text: "Heatmap: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "Here you can explore your user input data over time. You can click a field to see the exact value."),
                    ],
                  ),
                ),
              ),
              buildHeatMap(),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the heatmap widget
  Widget buildHeatMap() {
    Map<int, Color> colorsets = {};
    if (_lowestValue != null && _highestValue != null) {
      for (int i = _lowestValue!; i <= _highestValue!; i++) {
        colorsets[i] = _getColorForMood(i, _lowestValue!, _highestValue!);
      }
    }

    return HeatMap(
      datasets: datasets,
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      colorsets: colorsets,
      onClick: (DateTime date) {
        final mood = datasets[date];
        if (mood != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your mood on ${formatter.format(date)} was "$mood"')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No mood data for ${formatter.format(date)}')),
          );
        }
      },
    );
  }

  // Returns the color for the mood value
  Color _getColorForMood(int mood, int lowestValue, int highestValue) {
    const Color startColor = Color.fromARGB(255, 47, 75, 107);
    const Color endColor = Color.fromARGB(255, 47, 75, 107);
    //const Color startColor = Color.fromRGBO(180, 180, 180, 1);
    //const Color endColor = Color.fromRGBO(70, 220, 83, 1);
    double ratio = (mood - lowestValue) / (highestValue - lowestValue).toDouble();
    int r = startColor.red + ((endColor.red - startColor.red) * ratio).round();
    int g = startColor.green + ((endColor.green - startColor.green) * ratio).round();
    int b = startColor.blue + ((endColor.blue - startColor.blue) * ratio).round();
    return Color.fromRGBO(r, g, b, 1);
  }
}
