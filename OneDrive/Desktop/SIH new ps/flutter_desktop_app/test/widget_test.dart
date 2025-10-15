// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_desktop_app/main.dart';
import 'package:flutter_desktop_app/provider/theme_provider.dart';
import 'package:flutter_desktop_app/provider/language_provider.dart';
import 'package:flutter_desktop_app/provider/admin_provider.dart';

void main() {
  testWidgets('App shows title', (WidgetTester tester) async {
    // Build app wrapped with the same providers used in main.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => AdminProvider()),
        ],
        child: const DPRAssessmentApp(),
      ),
    );

    // Wait for localization and other async setup.
    await tester.pumpAndSettle();

    // Verify that the app title is present in the AppBar.
    expect(find.text('Vistaar'), findsOneWidget);
  });
}
