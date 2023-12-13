import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedUnit = 'Celsius';

  @override
  void initState() {
    super.initState();
    loadSavedUnit();
  }
Future<void> loadSavedUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedUnit = prefs.getString('temperatureUnit') ?? 'Celsius';
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Temperature Unit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Celsius'),
              leading: Radio(
                value: 'Celsius',
                groupValue: selectedUnit,
                onChanged: (value) {
                  setState(() {
                    selectedUnit = value as String;
                  });
                },
                key: Key('celsiusRadio')
              ),
            ),
            ListTile(
              title: const Text('Fahrenheit'),
              leading: Radio(
                value: 'Fahrenheit',
                groupValue: selectedUnit,
                onChanged: (value) {
                  setState(() {
                    selectedUnit = value as String;
                  });
                },
                key: Key('fahrenheitRadio'), 
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('temperatureUnit', selectedUnit);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
