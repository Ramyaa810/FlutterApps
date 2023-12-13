import 'package:flutter/material.dart';
import 'package:mp5/model/weatherLocation.dart';
import 'package:mp5/utils/databasehelper.dart';

class AddLocationPage extends StatelessWidget {
  final TextEditingController _cityController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  final VoidCallback onNavigateBack;
  AddLocationPage({super.key, required this.onNavigateBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a city to your favourites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Enter City Name'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await onAddLocationPressed(context);
                Navigator.pop(context);
                onNavigateBack();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onAddLocationPressed(BuildContext context) async {
    await addLocation(_cityController.text.trim());
  }

  Future<void> addLocation(String cityName) async {
    final newLocation = WeatherLocation(
      id: 0,
      name: cityName,
      temperature: 20.0,
      weatherCondition: 'Sunny',
    );
    await databaseHelper.insertWeatherLocation(newLocation);
  }
}
