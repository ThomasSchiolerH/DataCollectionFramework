import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart'; // Make sure to have intl in your pubspec.yaml

class CalendarScreen extends StatefulWidget {
  static const String routeName = "/calendar";

  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool showHeatMapCalendar = true;
  bool showInputFields = false; // State to control visibility of input fields
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final Map<DateTime, int> datasets = {
    DateTime(2021, 1, 6): 3,
    DateTime(2021, 1, 7): 7,
    DateTime(2021, 1, 8): 10,
    DateTime(2021, 1, 9): 13,
    DateTime(2021, 1, 13): 6,
  };

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _updateData() {
    DateTime? inputDate = formatter.parseStrict(_dateController.text);
    int? inputValue = int.tryParse(_valueController.text);

    if (inputDate != null && inputValue != null) {
      setState(() {
        datasets[inputDate] = inputValue;
        showInputFields = false; // Hide input fields after updating data
      });
    }
  }

  void _onDateClick(DateTime date) {
    setState(() {
      _dateController.text = formatter.format(date);
      showInputFields = true; // Show input fields
    });
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                showHeatMapCalendar = !showHeatMapCalendar;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (showInputFields) ...[
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                  ),
                  readOnly: true, // Make the date field read-only
                ),
                TextField(
                  controller: _valueController,
                  decoration: InputDecoration(
                    labelText: 'Value',
                  ),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _updateData,
                  child: Text('Update Data'),
                ),
                SizedBox(height: 20),
              ],
              showHeatMapCalendar ? buildHeatMapCalendar() : buildHeatMap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeatMapCalendar() {
    return HeatMapCalendar(
      defaultColor: Colors.white,
      flexible: true,
      colorMode: ColorMode.color,
      datasets: datasets,
      colorsets: colorsets,
      onClick: _onDateClick,
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
