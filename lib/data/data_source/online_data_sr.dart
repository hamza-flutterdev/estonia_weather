import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../model/weather_model.dart';
import '../model/forecast_model.dart';
import '../../presentation/home/controller/home_controller.dart';

class OnlineDataSource {
  static const baseUrl = "https://api.weatherapi.com/v1/forecast.json";
  final String apiKey;
  OnlineDataSource(this.apiKey);
  Future<(WeatherModel, List<ForecastModel>)> getWeatherAndForecast({
    required double lat,
    required double lon,
    int days = 7,
  }) async {
    final uri = Uri.parse(
      '$baseUrl?key=$apiKey&q=$lat,$lon&days=$days&aqi=yes&alerts=no',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final cityName = data['location']['name'] as String?;
      if (cityName != null) {
        HomeController.storeRawDataForCity(cityName, data);
      }
      try {
        final homeController = Get.find<HomeController>();
        if (cityName != null && cityName == homeController.mainCityName) {
          homeController.rawForecastData.value = data;
        }
      } catch (e) {
        debugPrint('HomeController not found or error updating raw data: $e');
      }
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
