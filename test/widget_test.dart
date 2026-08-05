import 'package:flutter_test/flutter_test.dart';
import 'package:kicksvibe/core/routes/app_router.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/main.dart';

void main() {
  testWidgets('shows the first onboarding page', (tester) async {
    await tester.pumpWidget(
      MyApp(
        appRouter: AppRouter(),
        initialRoute: AppRoutes.onboarding,
      ),
    );
    await tester.pump();

    expect(find.text('Start Journey\nWith Nike'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
