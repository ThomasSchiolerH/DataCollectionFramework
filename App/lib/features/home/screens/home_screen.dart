import 'package:flutter/material.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.name}!'),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                    user.toJson(),
                  ),
          )),
    );
  }
}
