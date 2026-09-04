import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/features/onboarding/presentation/pages/onboarding_screen.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  testWidgets('shows the first onboarding page', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
    await tester.pump();

    expect(find.text('Start Journey\nWith Nike'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
