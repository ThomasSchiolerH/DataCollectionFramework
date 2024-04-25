import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_app/features/user_input/screens/user_input_data_screen.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:mental_health_app/models/user.dart';
import 'package:mental_health_app/features/user_input/services/user_input_services.dart';

void main() {
  group('UserInputService Tests', () {
    late UserProvider userProvider;
    late UserInputService service;

    setUp(() {
      userProvider = UserProvider();
      userProvider.setUserFromModel(User(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
        age: 30,
        gender: 'Male',
        type: 'user',
        token: 'dummy_token',
      ));
      service = UserInputService();
    });

    testWidgets('postUserInput simulates posting data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>(
          create: (_) => userProvider,
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
// Simulate posting user input
                      service.postUserInput(
                        context: context,
                        type: 'mood',
                        value: 5,
                        date: DateTime.now(),
                      );
                    },
                    child: const Text('Test Post User Input'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Trigger the onPressed to simulate calling the postUserInput method
      await tester.tap(find.text('Test Post User Input'));
      await tester.pump(); // This is necessary to complete any pending tasks
    });
  });

  group('MoodScreen Tests', () {
    late UserProvider userProvider;

    setUp(() {
      userProvider = UserProvider();
      userProvider.setUserFromModel(User(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
        age: 30,
        gender: 'Male',
        type: 'user',
        token: 'dummy_token',
      ));
    });

    testWidgets('MoodScreen builds and displays custom user message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>(
          create: (_) => userProvider,
          child: MaterialApp(
            home: const MoodScreen(),
          ),
        ),
      );

      // Initial loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // After data fetching and state update simulation
      await tester
          .pumpAndSettle(); // This will settle the Scaffold and other widgets

      // Check for the presence of UI elements
      expect(find.text('User Input Data'), findsOneWidget);
    });
  });
}
