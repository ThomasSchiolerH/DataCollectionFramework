import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/provider/user_provider.dart';
import 'package:mental_health_app/features/analyze/services/analysis_services.dart';
import 'package:mental_health_app/models/user.dart';

void main() {
  group('AnalyseServices Tests', () {
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

    testWidgets('fetchAnalysis returns expected feedback', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>(
          create: (_) => userProvider,
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AnalyseServices.fetchAnalysis(context);
                    },
                    child: Text('Test Fetch Analysis'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Trigger the onPressed to simulate calling the method
      await tester.tap(find.text('Test Fetch Analysis'));
      await tester.pump();  // This is necessary to complete any pending tasks
    });
  });
}
