import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  static const String routeName = "/calendar";

  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This is the Calendar Screen'),
          // Remove the obsolete button
        ],
      ),
    );
  }
}
