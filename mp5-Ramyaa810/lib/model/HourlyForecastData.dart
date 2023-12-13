class HourlyForecastData {
  final int dateTime;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;

  HourlyForecastData({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
  });

  factory HourlyForecastData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    DateTime forecastTime =
        DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true);
    int formattedTime = forecastTime.hour;
    return HourlyForecastData(
      dateTime: formattedTime,
      temperature: main['temp'].toDouble(),
      feelsLike: main['feels_like'].toDouble(),
      tempMin: main['temp_min'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      pressure: main['pressure'],
      humidity: main['humidity'],
      weatherMain: weather['main'],
      weatherDescription: weather['description'],
      weatherIcon: weather['icon'],
    );
  }
}
