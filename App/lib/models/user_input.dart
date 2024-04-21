class UserInput {
  final String type;
  final num value;
  final DateTime date; 

  UserInput({
    required this.type,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'value': value,
      'date': date.toIso8601String(),
    };
  }

  factory UserInput.fromMap(Map<String, dynamic> map) {
    return UserInput(
      type: map['type'] as String? ?? '',
      value: map['value'] ?? 0,
      date: DateTime.parse(map['date']),
    );
  }
}
