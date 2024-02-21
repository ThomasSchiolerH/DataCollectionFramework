import 'package:flutter/material.dart';

class AnalyseScreen extends StatelessWidget {
  static const String routeName = '/analyse';

  const AnalyseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse'),
      ),
      body: const Center(
        child: Text('This is the Analyse Screen'),
      ),
    );
  }
}
