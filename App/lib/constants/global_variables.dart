import 'package:flutter/material.dart';

//String IP = "192.168.8.159"; // Home
String IP = "10.209.158.251"; // DTU
//String IP = "172.23.59.180"; // CBS
//String IP = "10.209.78.93";
String uri = "http://$IP:3000";

class GlobalVariables {
  static const secondaryColor = Color.fromARGB(255, 47, 75, 107);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color.fromRGBO(244,244,244, 1);
  static const selectedNavBarColor = Color.fromARGB(255, 94, 147, 207);
  static const unselectedNavBarColor = Color.fromRGBO(32, 46, 60, 1);
}