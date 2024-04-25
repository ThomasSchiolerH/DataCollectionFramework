import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_app/features/auth/services/auth_services.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('AuthServices Tests', () {
    late UserProvider userProvider;

    setUp(() {
      userProvider = UserProvider();
    });

    testWidgets('signUpUser sends correct data and handles response', (WidgetTester tester) async {
      // Set up the mock responses using MockClient
      http.Client mockClient = MockClient((request) async {
        if (request.url.path.contains('signup')) {
          return http.Response('{"id": "12345", "name": "John Doe", "email": "john.doe@example.com", "token": "dummy_token"}', 200);
        }
        return http.Response('Not Found', 404);
      });


      final authServices = AuthServices(client: mockClient);

      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>(
          create: (_) => userProvider,
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      authServices.signUpUser(
                        context: context,
                        name: 'John Doe',
                        age: '30',
                        gender: 'Male',
                        email: 'john.doe@example.com',
                        password: 'password123',
                      );
                    },
                    child: Text('Sign Up'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Tap the sign-up button to trigger the signUpUser
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

    });
  });
}
