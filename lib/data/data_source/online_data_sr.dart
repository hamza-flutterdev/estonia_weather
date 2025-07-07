import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';
import '../model/forecast_model.dart';

class OnlineDataSource {
  static const baseUrl = "https://api.weatherapi.com/v1/forecast.json";
  final String apiKey;

  OnlineDataSource(this.apiKey);

  Future<(WeatherModel, List<ForecastModel>)> getWeatherAndForecast(
    String cityName, {
    int days = 7,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl?key=$apiKey&q=$cityName&days=$days&aqi=no&alerts=no'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final current = WeatherModel.fromForecastJson(data);

      final forecastDays = data['forecast']['forecastday'] as List;
      final forecast =
          forecastDays.map((e) => ForecastModel.fromJson(e)).toList();

      return (current, forecast);
    } else {
      throw Exception(
        'Failed to fetch weather and forecast data: ${response.statusCode}',
      );
    }
  }
}
