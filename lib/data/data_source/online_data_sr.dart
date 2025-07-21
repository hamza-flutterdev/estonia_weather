import 'dart:convert';
import 'package:estonia_weather/core/common/app_exceptions.dart';
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
        HomeController.cacheCityData(cityName, data);
      }
      final homeController = Get.find<HomeController>();
      homeController.rawForecastData.value = data;
      final current = WeatherModel.fromForecastJson(data);
      final forecastDays = data['forecast']['forecastday'] as List;
      final forecast =
          forecastDays.map((e) => ForecastModel.fromJson(e)).toList();
      return (current, forecast);
    } else {
      throw Exception('$failedApiCall: ${response.statusCode}');
    }
  }

  Future<String> getCity(double lat, double lon) async {
    final uri = Uri.parse('$baseUrl?key=$apiKey&q=$lat,$lon');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final cityName = data['location']['name'] as String?;

      if (cityName != null) {
        return cityName;
      } else {
        throw Exception(noCityInApi);
      }
    } else {
      throw Exception('$failedApiCall: ${response.statusCode}');
    }
  }
}
