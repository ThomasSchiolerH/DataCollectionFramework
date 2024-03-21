import 'package:mental_health_app/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    age: 0,
    gender: '',
    email: '',
    password: '',
    type: '',
    token: '',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
  
  void clearUser() {
  _user = User(
    id: '',
    name: '',
    age: 0,
    gender: '',
    email: '',
    password: '',
    type: '',
    token: '',
  );
  notifyListeners();
}

}
