import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';

class OnlineDataSource {
  static const baseURL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  OnlineDataSource(this.apiKey);

  Future<WeatherModel> getWeatherByCity(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseURL?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch weather data: ${response.statusCode}');
    }
  }
}
