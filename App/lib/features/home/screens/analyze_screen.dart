import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/analyse_services.dart';

class AnalyseScreen extends StatefulWidget {
  static const String routeName = '/analyse';

  const AnalyseScreen({Key? key}) : super(key: key);

  @override
  _AnalyseScreenState createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  String feedback = "Fetching analysis...";
  List<dynamic> moodAnalysisData = []; // Store mood analysis data

  @override
  void initState() {
    super.initState();
    fetchAnalysisAndMoodData();
  }

  Future<void> fetchAnalysisAndMoodData() async {
    // Fetch analysis feedback
    String fetchedFeedback = await AnalyseServices.fetchAnalysis(context);
    // Fetch mood analysis data
    List<dynamic> fetchedMoodAnalysis = await AnalyseServices.fetchMoodAnalysis(context);
    setState(() {
      feedback = fetchedFeedback;
      moodAnalysisData = fetchedMoodAnalysis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse'),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to accommodate varying content lengths
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...moodAnalysisData.map((data) => Card(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: ListTile(
                  title: Text('Mood ${data['mood']}'),
                  subtitle: Text(
                    'Steps: ${data['avgSteps']}, Exercise Time: ${data['avgExerciseTime']}, Sleep: ${data['avgSleep']}, BMI: ${data['avgBMI']}',
                  ),
                ),
              )).toList(),
              const SizedBox(height: 20), // Spacing before the feedback text
              Text(feedback, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
