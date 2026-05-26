import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluxapay/features/auth/presentation/login_screen.dart';
import 'package:fluxapay/features/auth/presentation/register_screen.dart';

void main() {
  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: LoginScreen()),
    ));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('RegisterScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: RegisterScreen()),
    ));

    expect(find.text('Create Account'), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Login validation works', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: LoginScreen()),
    ));

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsNWidgets(2));
  });
}
