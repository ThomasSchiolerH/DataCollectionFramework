import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String type; 

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'type': type
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User (
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}