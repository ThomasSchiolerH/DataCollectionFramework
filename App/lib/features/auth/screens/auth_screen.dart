import 'package:flutter/material.dart';
import 'package:mental_health_app/features/auth/services/auth_services.dart';
import 'package:mental_health_app/features/user_input/screens/user_input_data_screen.dart';
import 'package:mental_health_app/features/project/screens/no_project_screen.dart';
import 'package:mental_health_app/features/project/screens/accept_decline_project.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthServices authServices = AuthServices();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  String _authMode = 'createAccount';
  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _handleAuthModeChange(String? value) {
    if (value != null) {
      setState(() {
        _authMode = value;
      });
    }
  }

  void signUpUser() {
    if (_signUpFormKey.currentState!.validate()) {
      authServices.signUpUser(
        context: context,
        name: _nameController.text,
        age: _ageController.text,
        gender: _selectedGender!,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  void signInUser() {
    authServices.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void navigateBasedOnProjectResponse(String? response) {
  switch (response) {
    case 'Accepted':
      Navigator.pushReplacementNamed(context, MoodScreen.routeName);
      break;
    case 'Declined':
      Navigator.pushReplacementNamed(context, IfDeclinedScreen.routeName);
      break;
    case 'NotAnswered':
      Navigator.pushReplacementNamed(context, AcceptProjectScreen.routeName);
      break;
    default: 
      Navigator.pushReplacementNamed(context, IfDeclinedScreen.routeName);
      break;
  }
}

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age cannot be empty';
    }
    final age = int.tryParse(value);
    if (age == null || age < 17) {
      return 'Please enter a valid age';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final regex = RegExp(
        r'^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$');
    if (value == null || !regex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Form(
          key: _authMode == 'createAccount' ? _signUpFormKey : _signInFormKey,
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
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: _validateName,
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: _validateAge,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Please select your gender' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_signUpFormKey.currentState!.validate()) {
                      signUpUser();
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ] else if (_authMode == 'login') ...[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_signInFormKey.currentState!.validate()) {
                      signInUser();
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
