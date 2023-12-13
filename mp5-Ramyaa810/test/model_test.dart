import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/model/HourlyForecastData.dart';
import 'package:mp5/model/weatherLocation.dart';

void main() {
  group('WeatherLocation Model Tests', () {
    test('WeatherLocation toMap() should return a valid map', () {
      final weatherLocation = WeatherLocation(
        id: 1,
        name: 'City',
        temperature: 25.0,
        weatherCondition: 'Sunny',
      );

      final map = weatherLocation.toMap();
      expect(map['name'], 'City');
      expect(map['temperature'], closeTo(25.0, 0.001));
      expect(map['weather_condition'], 'Sunny');
    });

    test('WeatherLocation toMap() should handle zero temperature', () {
      final weatherLocation = WeatherLocation(
        id: 2,
        name: 'AnotherCity',
        temperature: 0.0,
        weatherCondition: 'Cloudy',
      );

      final map = weatherLocation.toMap();
      expect(map['name'], 'AnotherCity');
      expect(map['temperature'], closeTo(0.0, 0.001));
      expect(map['weather_condition'], 'Cloudy');
    });

    test('WeatherLocation toMap() should handle negative temperature', () {
      final weatherLocation = WeatherLocation(
        id: 3,
        name: 'NegativeCity',
        temperature: -5.0,
        weatherCondition: 'Snowy',
      );

      final map = weatherLocation.toMap();
      expect(map['name'], 'NegativeCity');
      expect(map['temperature'], closeTo(-5.0, 0.001));
      expect(map['weather_condition'], 'Snowy');
    });

    test('WeatherLocation toMap() should handle null temperature', () {
      final weatherLocation = WeatherLocation(
        id: 4,
        name: 'NullCity',
        temperature: null,
        weatherCondition: 'Rainy',
      );

      final map = weatherLocation.toMap();
      expect(map['name'], 'NullCity');
      expect(map['temperature'], isNull);
      expect(map['weather_condition'], 'Rainy');
    });

    test('WeatherLocation toMap() should handle empty name', () {
      final weatherLocation = WeatherLocation(
        id: 5,
        name: '',
        temperature: 15.0,
        weatherCondition: 'Windy',
      );

      final map = weatherLocation.toMap();
      expect(map['name'], '');
      expect(map['temperature'], closeTo(15.0, 0.001));
      expect(map['weather_condition'], 'Windy');
    });
  });

  group('HourlyForecastData', () {
    test('HourlyForecastData should be initialized correctly', () {
      final hourlyForecastData = HourlyForecastData(
        dateTime: 12,
        temperature: 28.0,
        feelsLike: 26.0,
        tempMin: 25.0,
        tempMax: 30.0,
        pressure: 1015,
        humidity: 70,
        weatherMain: 'Clear',
        weatherDescription: 'Clear sky',
        weatherIcon: '01d',
      );

      expect(hourlyForecastData.dateTime, 12);
      expect(hourlyForecastData.temperature, 28.0);
      expect(hourlyForecastData.feelsLike, 26.0);
    });

    test('HourlyForecastData should handle null values', () {
      Map<String, dynamic> jsonData = {
        'dt': 1639228800,
        'main': {
          'temp': 25.5,
          'feels_like': 26.0,
          'temp_min': 25.0,
          'temp_max': 26.0,
          'pressure': 1010,
          'humidity': 80,
        },
        'weather': [
          {
            'main': 'Clear',
            'description': 'Clear sky',
            'icon': '01d',
          }
        ],
      };

      final hourlyForecastData = HourlyForecastData.fromJson(jsonData);

      expect(hourlyForecastData.dateTime, isNotNull);
      expect(hourlyForecastData.temperature, isNotNull);
      expect(hourlyForecastData.feelsLike, isNotNull);
      expect(hourlyForecastData.tempMin, isNotNull);
      expect(hourlyForecastData.tempMax, isNotNull);
      expect(hourlyForecastData.pressure, isNotNull);
      expect(hourlyForecastData.humidity, isNotNull);
      expect(hourlyForecastData.weatherMain, isNotNull);
      expect(hourlyForecastData.weatherDescription, isNotNull);
      expect(hourlyForecastData.weatherIcon, isNotNull);
    });
  });
}
