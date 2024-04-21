import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_app/constants/utilities.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:mental_health_app/constants/global_variables.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:mental_health_app/features/program/screens/user_input_data_screen.dart';
import 'package:mental_health_app/features/program/screens/no_project_screen.dart';

class project {
  final String? projectName;
  final String? message;
  final String? inputType;
  final int? lowestValue;
  final int? highestValue;
  final DateTime? messageExpiration;
  final Map<String, bool>? enabledSensors;

  project({
    this.projectName,
    this.message,
    this.inputType,
    this.lowestValue,
    this.highestValue,
    this.messageExpiration,
    this.enabledSensors,
  });

  factory project.fromJson(Map<String, dynamic> json) {
    return project(
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
  project? _project;

  @override
  void initState() {
    super.initState();
    _fetchproject();
  }

  Future<void> _fetchproject() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user.id;

    try {
      final response = await http.get(
        Uri.parse('$uri/api/users/$userId/project'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _project = project.fromJson(data);
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
      }
    } catch (e) {
      showSnackBar2(context, 'Exception caught during update: $e',
          isError: true);
    }
  }

  List<Widget> _buildSensorsList() {
    return _project?.enabledSensors?.entries.map((entry) {
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
                        if (_project?.projectName != null)
                          Text('Project: ${_project!.projectName}',
                              style: Theme.of(context).textTheme.titleLarge),
                        if (_project?.message != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Message: ${_project!.message}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        if (_project?.inputType != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Input Type: ${_project!.inputType}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        if (_project?.lowestValue != null &&
                            _project?.highestValue != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                'Values Range: ${_project!.lowestValue} - ${_project!.highestValue}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        if (_project?.messageExpiration != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                'Expires On: ${_project!.messageExpiration!.toIso8601String()}',
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
