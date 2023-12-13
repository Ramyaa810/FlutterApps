class WeatherLocation {
  final int id;
  final String name;
   double? temperature;
   String weatherCondition;

  WeatherLocation({
    required this.id,
    required this.name,
    required this.temperature,
    required this.weatherCondition,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'temperature': temperature,
      'weather_condition': weatherCondition,
    };
  }
}