import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/analyse_services.dart';
import 'package:provider/provider.dart';

class AnalyseScreen extends StatefulWidget {
  static const String routeName = '/analyse';

  const AnalyseScreen({Key? key}) : super(key: key);

  @override
  _AnalyseScreenState createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  String feedback = "Fetching analysis...";

  @override
  void initState() {
    super.initState();
    fetchAnalysis();
  }

  Future<void> fetchAnalysis() async {
    String fetchedFeedback = await AnalyseServices.fetchAnalysis(context);
    setState(() {
      feedback = fetchedFeedback;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(feedback, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
