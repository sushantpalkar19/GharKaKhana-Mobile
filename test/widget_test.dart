import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gharkakhana_mobile/core/constants.dart';
import 'package:gharkakhana_mobile/providers/auth_provider.dart';
import 'package:gharkakhana_mobile/screens/splash_screen.dart';

void main() {
  testWidgets(
    'SplashScreen waits for premium intro before navigating to login',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(_buildSplashApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 2999));

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('Login Route'), findsNothing);

      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('Login Route'), findsOneWidget);
    },
  );

  testWidgets('SplashScreen navigates to home after intro when auth is ready', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      AppConstants.accessTokenKey: 'test-token',
      AppConstants.userKey: jsonEncode({
        '_id': 'user-1',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'role': AppConstants.roleCustomer,
      }),
    });

    await tester.pumpWidget(_buildSplashApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.text('Home Route'), findsOneWidget);
  });
}

Widget _buildSplashApp() {
  return ChangeNotifierProvider(
    create: (_) => AuthProvider()..init(),
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const Scaffold(body: Text('Login Route')),
        '/home': (context) => const Scaffold(body: Text('Home Route')),
      },
    ),
  );
}
