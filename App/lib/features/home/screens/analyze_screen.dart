import 'package:flutter/material.dart';
import 'package:mental_health_app/features/home/services/analysis_services.dart';

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
    List<dynamic> fetchedMoodAnalysis =
        await AnalyseServices.fetchMoodAnalysis(context);
    setState(() {
      feedback = fetchedFeedback;
      moodAnalysisData = fetchedMoodAnalysis;
    });
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> intersperseSizedBox(Iterable<Widget> widgets) {
      var list = widgets
          .expand((widget) => [widget, const SizedBox(height: 10)])
          .toList();
      if (list.isNotEmpty) {
        list.removeLast();
      }
      return list;
    }

    String formatNumber(dynamic number) {
      // Parse the number to ensure it's treated as a double
      double value = double.parse(number.toString());
      // Check if the number is an integer
      if (value == value.toInt()) {
        // If yes, return it as an integer string
        return value.toInt().toString();
      } else {
        // If not, return it rounded to two decimal places
        return value.toStringAsFixed(2);
      }
    }

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
              ...intersperseSizedBox(
                moodAnalysisData
                    .map((data) => Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: ListTile(
                            title: Text(
                              'Mood ${data['mood']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
