import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mp5/model/HourlyForecastData.dart';
import 'package:mp5/model/weatherLocation.dart';
import 'package:mp5/utils/apiconnect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailedWeatherPage extends StatefulWidget {
  final WeatherLocation weatherLocation;
  final VoidCallback onNavigateBack;

  const DetailedWeatherPage(
      {super.key, required this.weatherLocation, required this.onNavigateBack});

  @override
  _DetailedWeatherPageState createState() => _DetailedWeatherPageState();
}

class _DetailedWeatherPageState extends State<DetailedWeatherPage> {
  final WeatherApi weatherApi = WeatherApi();
  double? latitude;
  double? longitude;
  String? cityName;
  double? temperature;
  String? weatherCondition;
  double? feelsLike;
  double? pressure;
  double? humidity;
  double? visibility;
  List<HourlyForecastData> hourlyForecast = [];
  bool isLoading = true;
  String? selectedUnit;

  @override
  void initState() {
    super.initState();
    fetchDetailedWeather();
  }

  Future<void> fetchDetailedWeather() async {
    try {
      final coordinates =
          await weatherApi.getCoordinates(widget.weatherLocation.name);
      final apiResponse = await weatherApi.getTemperatureAndCondition(
        coordinates['latitude'],
        coordinates['longitude'],
      );
      final hourlyForecastResponse = await weatherApi.getHourly(
          coordinates['latitude'], coordinates['longitude']);
      final List<dynamic> hourlyForecastList =
          hourlyForecastResponse['list'] ?? [];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        latitude = coordinates['latitude'];
        longitude = coordinates['longitude'];
        cityName = widget.weatherLocation.name;
        temperature = apiResponse['temperature'];
        weatherCondition = apiResponse['weatherCondition'];
        feelsLike = apiResponse['feelslike'];
        pressure = apiResponse['pressure'];
        humidity = apiResponse['humidity'];
        visibility = apiResponse['visibility'];
        selectedUnit = prefs.getString('temperatureUnit') ?? 'Celsius';
        if (selectedUnit == 'Celsius') {
          selectedUnit = '°C';
        } else {
          selectedUnit = 'F';
        }
        hourlyForecast = hourlyForecastList
            .map((hourlyData) => HourlyForecastData.fromJson(hourlyData))
            .toList();
        hourlyForecast.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching detailed weather data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void onBackButtonPressed() {
    Navigator.pop(context);
    widget.onNavigateBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Report - $cityName'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Additional Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('Current Datetime: ${DateTime.now()}'),
                    Text('Current Temperature: $temperature $selectedUnit'),
                    Text('Feels Like Temperature: $feelsLike $selectedUnit'),
                    Text('Current Weather Description: $weatherCondition'),
                    Text('Humidity: $humidity %'),
                    Text(
                        'Visibility: ${visibility != null ? visibility! / 1000 : 'N/A'} Km'),
                    const SizedBox(height: 20),
                    const Text(
                      'Hourly Forecast in 24 hour format',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    Container(
                      height: 200,
                      padding: const EdgeInsets.only(top: 10),
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                              showTitles: true,
                              margin: 16,
                              reservedSize: 30,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              getTitles: (value) {
                                return value.toInt().toString();
                              },
                              interval: 3,
                            ),
                            bottomTitles: SideTitles(
                              showTitles: true,
                              margin: 16,
                              reservedSize: 30,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              getTitles: (value) {
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index < hourlyForecast.length - 3) {
                                  final dateTime =
                                      hourlyForecast[index].dateTime;
                                  return '${dateTime}';
                                }
                                return '';
                              },
                              interval: 5,
                            ),
                            rightTitles: SideTitles(showTitles: false),
                            topTitles: SideTitles(showTitles: false),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: hourlyForecast
                                  .asMap()
                                  .entries
                                  .map((entry) => FlSpot(
                                        entry.key.toDouble(),
                                        entry.value.feelsLike,
                                      ))
                                  .toList(),
                              isCurved: true,
                              belowBarData: BarAreaData(show: false),
                              aboveBarData: BarAreaData(show: false),
                            ),
                          ],
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
