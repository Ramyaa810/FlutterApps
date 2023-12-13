import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mp5/views/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Settings Page functionality', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(MaterialApp(
      home: SettingsPage(),
    ));

    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.byKey(const Key('fahrenheitRadio')));
    await tester.pumpAndSettle();
    expect(find.text('Fahrenheit'), findsOneWidget);

    await tester.tap(find.byKey(const Key('celsiusRadio')));
    await tester.pumpAndSettle();

    expect(find.text('Celsius'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedUnit = prefs.getString('temperatureUnit');

    expect(savedUnit, 'Celsius');
    await tester.pumpAndSettle();
  });
}
