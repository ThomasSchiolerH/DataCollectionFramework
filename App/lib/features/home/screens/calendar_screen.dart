import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class CalendarScreen extends StatelessWidget {
  static const String routeName = "/calendar";

  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Calendar Screen'),
          HeatMapCalendar(
            defaultColor: Colors.white,
            flexible: true,
            colorMode: ColorMode.color,
            datasets: {
              DateTime(2024, 1, 6): 1,
              DateTime(2024, 1, 7): 5,
              DateTime(2024, 1, 8): 2,
              DateTime(2024, 1, 9): 3,
              DateTime(2024, 1, 13): 4,
            },
            colorsets: const {
              1: Color.fromARGB(255, 218, 140, 134),
              2: Color.fromARGB(255, 227, 110, 110),
              3: Color.fromARGB(255, 231, 76, 76),
              4: Color.fromARGB(255, 234, 52, 52),
              5: Color.fromARGB(255, 239, 7, 7),
            },
            onClick: (value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
            },
          ),
        ],
      ),
    );
  }
}
