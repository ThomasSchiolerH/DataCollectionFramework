import 'package:flutter/material.dart';
//String IP = "000.000.0.00"; // Enter your IP
String IP = "192.168.1.14"; //HJEMME
//String IP = "10.209.162.133"; //DTU1
//String IP = "10.209.79.93"; //DTU2
//String IP = "10.63.74.109"; //PARENTS
//String IP = "172.23.83.158"; //CBS
String uri = "http://$IP:3000";

class GlobalVariables {

  static const secondaryColor = Color.fromARGB(255, 47, 75, 107);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color.fromRGBO(244,244,244, 1);
  static const selectedNavBarColor = Color.fromARGB(255, 94, 147, 207);
  static const unselectedNavBarColor = Color.fromRGBO(32, 46, 60, 1);

}