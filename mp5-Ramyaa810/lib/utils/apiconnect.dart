import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherApi {
  final String apiKey = '19cfb7c8b5d3fcc716eee0fff9e5dfa2';
  final String geocodingBaseUrl =
      'https://api.openweathermap.org/geo/1.0/direct';
  final String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5/';

  WeatherApi();

  Future<Map<String, dynamic>> getCoordinates(String cityName) async {
    final geourl = '$geocodingBaseUrl?q=$cityName&limit=1&appid=$apiKey';
    final response = await http.get(Uri.parse(geourl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty) {
        final coordinates = jsonResponse[0];
        return {
          'latitude': coordinates['lat'].toDouble(),
          'longitude': coordinates['lon'].toDouble(),
        };
      }
    }

    throw Exception('Failed to get coordinates for the city');
  }

  Future<String> getTemperatureUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('temperatureUnit') ?? 'Celsius';
  }

  Future<Map<String, dynamic>> getTemperatureAndCondition(
      double latitude, double longitude) async {
    String temperatureUnit = await getTemperatureUnit();
    if (temperatureUnit == 'Celsius') {
      temperatureUnit = 'metric';
    } else {
      temperatureUnit = 'imperial';
    }
    final weatheruri =
        '$weatherBaseUrl/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=$temperatureUnit';
    final response = await http.get(Uri.parse(weatheruri));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return {
        'temperature': jsonResponse['main']['temp'].toDouble(),
        'weatherCondition': jsonResponse['weather'][0]['main'],
        'feelslike': jsonResponse['main']['feels_like'].toDouble(),
        'pressure': jsonResponse['main']['pressure'].toDouble(),
        'humidity': jsonResponse['main']['humidity'].toDouble(),
        'visibility': jsonResponse['visibility'].toDouble(),
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getHourly(
      double latitude, double longitude) async {
    final weatheruri =
        '$weatherBaseUrl/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(weatheruri));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
