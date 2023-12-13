import 'package:flutter/material.dart';
import 'package:mp5/model/weatherLocation.dart';
import 'package:mp5/utils/apiconnect.dart';
import 'package:mp5/utils/databasehelper.dart';
import 'package:mp5/views/add_location.dart';
import 'package:mp5/views/detailed_weather_page.dart';
import 'package:mp5/views/search_city.dart';
import 'package:mp5/views/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherLocation> favoriteLocations = [];
  final WeatherApi weatherApi = WeatherApi();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  String? selectedUnit;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadWeatherLocations();
    
  }

   Future<void> _loadWeatherLocations() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final locations = await databaseHelper.getWeatherLocations();

    selectedUnit = prefs.getString('temperatureUnit') ?? 'Celsius';
    if (selectedUnit == 'Celsius') {
      selectedUnit = '°C';
    } else {
      selectedUnit = 'F';
    }

    for (final location in locations) {
      try {
        final coordinates = await weatherApi.getCoordinates(location.name);
        final apiResponse = await weatherApi.getTemperatureAndCondition(
          coordinates['latitude'],
          coordinates['longitude'],
        );

        setState(() {
          location.temperature = apiResponse['temperature'];
          location.weatherCondition = apiResponse['weatherCondition'];
        });
      } catch (e) {
        print('Error fetching weather data for ${location.name}: $e');
      }
    }

    setState(() {
      favoriteLocations = locations;
      isLoading = false; 
    });
  }
void navigateToSearch(BuildContext context) async {
    await Navigator.push(
      context,      
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Weather App'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
            onPressed: () => navigateToSearch(context),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => navigateToAddLocation(context),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
            _loadWeatherLocations(); 
          },
        ),
      ],
    ),
    body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: favoriteLocations.length,
                  itemBuilder: (context, index) {
                    final location = favoriteLocations[index];
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(location.name),
                          ),
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      subtitle: Text(
                          '${location.temperature} $selectedUnit - ${location.weatherCondition}'),
                      onTap: () async {
                        await navigateToDetailedWeather(context, location);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await removeLocation(location.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
  );
}

  Future<void> removeLocation(int id) async {
    await databaseHelper.deleteWeatherLocation(id);
    await _loadWeatherLocations();
  }

  Future<void> navigateToDetailedWeather(BuildContext context, WeatherLocation location) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedWeatherPage(
          weatherLocation: location,
          onNavigateBack: () {
            _loadWeatherLocations();
          },
        ),
      ),
    );
  }
  Future<void> navigateToAddLocation(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddLocationPage(
      onNavigateBack:(){
        _loadWeatherLocations();
      }
    )),
  );
}
}

