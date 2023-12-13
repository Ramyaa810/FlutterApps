import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mp5/main.dart';
import 'package:mp5/utils/apiconnect.dart';
import 'package:mp5/views/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockWeatherApi extends Mock implements WeatherApi {}

void main() {
  group('HomePage Widget Tests', () {

    testWidgets('Changing the settings should update the UI',
        (WidgetTester tester) async {
          
      await tester.pumpWidget(MyWeatherApp());

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Adding a new location should update the UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyWeatherApp());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Add a city to your favourites'), findsOneWidget);
    });

    testWidgets('Navigating to SearchPage should work',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyWeatherApp());
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.text('Search City'), findsOneWidget);
    });

    testWidgets('Check if saved unit is displayed in HomePage',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final SharedPreferences prefs = await SharedPreferences.getInstance();     

      await tester.pumpWidget(MaterialApp(home: SettingsPage()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      prefs.setString('temperatureUnit', 'Fahrenheit');
      final savedUnit = prefs.getString('temperatureUnit');
      expect(savedUnit, 'Fahrenheit');
    });   

    testWidgets('Save button click should save preference',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(MaterialApp(home: SettingsPage()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final savedUnit = prefs.getString('temperatureUnit');
      expect(savedUnit, 'Celsius');
    });
    
  });
}
