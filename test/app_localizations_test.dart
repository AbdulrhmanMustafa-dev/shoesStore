import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';

void main() {
  Widget host(Locale locale) => MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Builder(builder: (context) => Text(context.l10n.accountSettings)),
  );

  testWidgets('loads all supported translations and Arabic directionality', (
    tester,
  ) async {
    await tester.pumpWidget(host(const Locale('en')));
    await tester.pumpAndSettle();
    expect(find.text('Account & Settings'), findsOneWidget);

    await tester.pumpWidget(host(const Locale('ar')));
    await tester.pumpAndSettle();
    expect(find.text('الحساب والإعدادات'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(Text))),
      TextDirection.rtl,
    );

    await tester.pumpWidget(host(const Locale('fr')));
    await tester.pumpAndSettle();
    expect(find.text('Compte et paramètres'), findsOneWidget);
  });
}
