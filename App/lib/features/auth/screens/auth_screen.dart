import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _authMode = 'createAccount';

  void _handleAuthModeChange(String? value) {
    if (value != null) {
      setState(() {
        _authMode = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text('Create Account'),
              leading: Radio<String>(
                value: 'createAccount',
                groupValue: _authMode,
                onChanged: _handleAuthModeChange,
              ),
            ),
            ListTile(
              title: const Text('Login'),
              leading: Radio<String>(
                value: 'login',
                groupValue: _authMode,
                onChanged: _handleAuthModeChange,
              ),
            ),
            if (_authMode == 'createAccount') ...[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add sign-up logic
                },
                child: Text('Sign Up'),
              ),
            ] else if (_authMode == 'login') ...[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add login logic
                },
                child: Text('Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
