import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/global_variables.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Health App',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Hello."),
        ),
        body: const Center(
          child: Text('Home Page'),
        ),
      ),
    );
  }
}
