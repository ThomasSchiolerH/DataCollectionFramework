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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  bool showInputFields = false;
  bool _isLoading = true;

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

      if (inputs != null) {
        for (var input in inputs) {
          if (input['type'] == 'mood') {
            // Parse the ISO date string directly to DateTime
            final DateTime? date = DateTime.tryParse(input['date']);
            final int? value = int.tryParse(input['value'].toString());

            if (date != null && value != null) {
              newDatasets[date] = value;
            } else {
              print("Failed to parse date or value for input: $input");
            }
          }
        }
      }

      setState(() {
        datasets = newDatasets;
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

  void _updateData() {
    DateTime? inputDate = formatter.parseStrict(_dateController.text);
    int? inputValue = int.tryParse(_valueController.text);

    if (inputDate != null && inputValue != null) {
      setState(() {
        datasets[inputDate] = inputValue;
        showInputFields = false;
      });
    }
  }

  void _onDateClick(DateTime date) {
    setState(() {
      _dateController.text = formatter.format(date);
      showInputFields = true;
    });
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
              if (showInputFields) ...[
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  readOnly: true,
                ),
                TextField(
                  controller: _valueController,
                  decoration: const InputDecoration(
                    labelText: 'Value',
                  ),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _updateData,
                  child: const Text('Update Data'),
                ),
                const SizedBox(height: 20),
              ],
              buildHeatMap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeatMap() {
    return HeatMap(
      datasets: datasets,
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      colorsets: colorsets,
      onClick: _onDateClick,
    );
  }

  final Map<int, Color> colorsets = {
    1: const Color.fromRGBO(244, 67, 54, 1),
    2: Color.fromARGB(255, 240, 122, 114),
    3: Color.fromARGB(255, 234, 174, 170),
    4: Color.fromARGB(255, 173, 234, 170),
    5: Color.fromARGB(255, 111, 233, 104),
    6: Colors.green,
  };
}
