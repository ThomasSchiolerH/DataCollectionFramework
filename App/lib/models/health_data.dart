class HealthData {
  final String type;
  final num value;
  final String unit;
  final DateTime date; // Storing the date for measurement recorded

  HealthData({
    required this.type,
    required this.value,
    required this.unit,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'value': value,
      'unit': unit,
      'date': date.toIso8601String(),
    };
  }

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      type: map['type'] as String? ?? '',
      value: map['value'] ?? 0,
      unit: map['unit'] as String? ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}