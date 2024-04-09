import 'dart:convert';
import 'package:mental_health_app/models/health_data.dart';

class User {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String email;
  final String password;
  final String type;
  final String token;
  final List<HealthData> healthData;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.password,
    required this.type,
    required this.token,
    this.healthData = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'email': email,
      'password': password,
      'type': type,
      'token': token,
      'healthData': healthData.map((x) => x.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      healthData: List<HealthData>.from(
          map['healthData']?.map((x) => HealthData.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
