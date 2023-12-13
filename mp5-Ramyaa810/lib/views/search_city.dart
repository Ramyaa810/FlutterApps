import 'package:flutter/material.dart';
import 'package:mp5/model/weatherLocation.dart';
import 'package:mp5/utils/apiconnect.dart';
import 'package:mp5/utils/databasehelper.dart';
import 'package:mp5/views/detailed_weather_page.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
WeatherApi weatherApi = WeatherApi();
DatabaseHelper databaseHelper = DatabaseHelper.instance;
  SearchPage({super.key}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Enter City Name'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => onSearchPressed(context),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void onSearchPressed(BuildContext context) {
     final   cityName = _searchController.text.trim();
     navigateToDetailedWeatherBySearch(context, cityName);
  }

  Future<void> navigateToDetailedWeatherBySearch(
    BuildContext context,
    String cityName,
  ) async {
    try {

      final coordinates = await weatherApi.getCoordinates(cityName);
      final apiResponse = await weatherApi.getTemperatureAndCondition(
        coordinates['latitude'],
        coordinates['longitude'],
      );

      final newLocation = WeatherLocation(
        id: 0,
        name: cityName,
        temperature: apiResponse['temperature'],
        weatherCondition: apiResponse['weatherCondition'],
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedWeatherPage(
            weatherLocation: newLocation,
            onNavigateBack: () {
               Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print('Error fetching weather data for $cityName: $e');
    }
  }
}

