import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_app/models/health_data.dart';

void main() {
  group('HealthData Model Tests', () {
    test('toMap serializes data correctly', () {
      final healthData = HealthData(
        type: 'heart_rate',
        value: 72,
        unit: 'bpm',
        date: DateTime(2023, 1, 15),
      );

      final map = healthData.toMap();

      expect(map['type'], equals('heart_rate'));
      expect(map['value'], equals(72));
      expect(map['unit'], equals('bpm'));
      expect(map['date'], equals('2023-01-15T00:00:00.000'));
    });

    test('fromMap deserializes data correctly', () {
      final map = {
        'type': 'heart_rate',
        'value': 72,
        'unit': 'bpm',
        'date': '2023-01-15T00:00:00.000',
      };

      final healthData = HealthData.fromMap(map);

      expect(healthData.type, equals('heart_rate'));
      expect(healthData.value, equals(72));
      expect(healthData.unit, equals('bpm'));
      expect(healthData.date, equals(DateTime(2023, 1, 15)));
    });
  });
}
