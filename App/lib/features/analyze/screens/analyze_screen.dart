import 'package:flutter/material.dart';
import 'package:mental_health_app/features/analyze/services/analysis_services.dart';

class AnalyseScreen extends StatefulWidget {
  static const String routeName = '/analyse';

  const AnalyseScreen({super.key});

  @override
  _AnalyseScreenState createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  String feedback = "Fetching analysis...";
  List<dynamic> moodAnalysisData = []; 

  @override
  void initState() {
    super.initState();
    fetchAnalysisAndMoodData();
  }

  // Fetches analysis data and mood data from the services and updates the state.
  Future<void> fetchAnalysisAndMoodData() async {
    String fetchedFeedback = await AnalyseServices.fetchAnalysis(context);
    List<dynamic> fetchedMoodAnalysis =
        await AnalyseServices.fetchMoodAnalysis(context);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.only(bottom: 10.0),
                child: ListTile(
                  title: const Text(
                    "Analysis",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(feedback),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...moodAnalysisData.map((data) { // Maps each mood analysis data entry to a card widget.
                String inputTypeTitle = data['inputType'] ?? "Not Fetched";
                int moodValue =
                    (data['moodValue'] is int) ? data['moodValue'] : 0;
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: ListTile(
                    title: Text(
                      '$inputTypeTitle value $moodValue',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Steps: ${formatNumber(data['avgSteps'])}\n'
                        'Exercise Time: ${formatNumber(data['avgExerciseTime'])}\n'
                        'Heart Rate: ${formatNumber(data['avgHeartRate'])}\n'
                        'BMI: ${formatNumber(data['avgBMI'])}',
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Formats the number to a string with 2 decimal places if it is a double.
  String formatNumber(dynamic number) {
    double value = double.tryParse(number.toString()) ?? 0;
    return value == value.toInt()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
  }
}
