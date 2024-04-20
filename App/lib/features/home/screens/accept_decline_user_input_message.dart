import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/utilities.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:mental_health_app/features/home/screens/mood_screen.dart';
import 'package:mental_health_app/features/home/screens/if_declined.dart';

class UserInputMessage {
  final String? projectName;
  final String? message;
  final String? inputType;
  final int? lowestValue;
  final int? highestValue;
  final DateTime? messageExpiration;
  final Map<String, bool>? enabledSensors;

  UserInputMessage({
    this.projectName,
    this.message,
    this.inputType,
    this.lowestValue,
    this.highestValue,
    this.messageExpiration,
    this.enabledSensors,
  });

  factory UserInputMessage.fromJson(Map<String, dynamic> json) {
    return UserInputMessage(
      projectName: json['projectName'],
      message: json['message'],
      inputType: json['inputType'],
      lowestValue: json['lowestValue'],
      highestValue: json['highestValue'],
      messageExpiration: json['messageExpiration'] != null
          ? DateTime.parse(json['messageExpiration'])
          : null,
      enabledSensors: json['enabledSensors'] != null
          ? Map<String, bool>.from(json['enabledSensors'])
          : null,
    );
  }
}

class AcceptProjectScreen extends StatefulWidget {
  static const String routeName = '/acceptProject';

  const AcceptProjectScreen({super.key});

  @override
  _AcceptProjectScreenState createState() => _AcceptProjectScreenState();
}

class _AcceptProjectScreenState extends State<AcceptProjectScreen> {
  bool _isLoading = true;
  UserInputMessage? _userInputMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserInputMessage();
  }

  Future<void> _fetchUserInputMessage() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user.id;

    try {
      final response = await http.get(
        Uri.parse('$uri/api/users/$userId/userInputMessage'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userInputMessage = UserInputMessage.fromJson(data);
          _isLoading = false;
        });
      } else {
        print('Error fetching custom user message: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Exception caught during fetch: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserResponse(String response) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user.id;

    try {
      final res = await http.patch(
        Uri.parse('$uri/api/users/$userId/updateResponse'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: jsonEncode({
          "projectResponse": response,
        }),
      );

      if (res.statusCode == 200) {
        String routeName = response == "Accepted"
            ? MoodScreen.routeName
            : IfDeclinedScreen.routeName;
        Navigator.pushReplacementNamed(context, routeName);
      } else {
        showSnackBar2(context, 'Failed to update response: ${res.body}',
            isError: true);
        //print('Failed to update response: ${res.body}');
      }
    } catch (e) {
      showSnackBar2(context, 'Exception caught during update: $e',
          isError: true);
      //print('Exception caught during update: $e');
    }
  }

  List<Widget> _buildSensorsList() {
    return _userInputMessage?.enabledSensors?.entries.map((entry) {
          return Text('${entry.key}: ${entry.value ? 'Enabled' : 'Disabled'}',
              style: const TextStyle(fontSize: 16));
        }).toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_userInputMessage?.projectName != null)
                          Text('Project: ${_userInputMessage!.projectName}',
                              style: Theme.of(context).textTheme.titleLarge),
                        if (_userInputMessage?.message != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                'Message: ${_userInputMessage!.message}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        if (_userInputMessage?.inputType != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                'Input Type: ${_userInputMessage!.inputType}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        if (_userInputMessage?.lowestValue != null &&
                            _userInputMessage?.highestValue != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                'Values Range: ${_userInputMessage!.lowestValue} - ${_userInputMessage!.highestValue}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        if (_userInputMessage?.messageExpiration != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                'Expires On: ${_userInputMessage!.messageExpiration!.toIso8601String()}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildSensorsList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => _updateUserResponse("Accepted"),
                              child: const Text('Accept'),
                            ),
                            ElevatedButton(
                              onPressed: () => _updateUserResponse("Declined"),
                              child: const Text('Decline'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
