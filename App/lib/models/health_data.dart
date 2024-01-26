class HealthData {
  final int steps;
  final DateTime date; // Storing the date for which the steps were recorded

  HealthData({required this.steps, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
      'date': date.toIso8601String(),
    };
  }

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      steps: map['steps'] ?? 0,
      date: DateTime.parse(map['date']),
    );
  }
}