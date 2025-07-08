import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';

class HomeController extends GetxController {
  final GetWeatherAndForecast getCurrentWeather;
  final ConditionController conditionController = Get.find();

  HomeController(this.getCurrentWeather);

  final selectedCities = <EstonianCity>[].obs;
  final mainCityIndex = 0.obs;
  final currentDate = ''.obs;
  final isLoading = false.obs;
  final allCities = <EstonianCity>[].obs;
  final selectedForecastIndex = 0.obs;
  final forecastData = <ForecastModel>[].obs;
  final currentOtherCityIndex = 0.obs;
  final rawForecastData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    updateCurrentDate();
    await loadAllCities();
  }

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat('EEEE dd MMMM').format(now);
  }

  Future<void> loadAllCities() async {
    try {
      isLoading.value = true;
      final String response = await rootBundle.loadString(
        'assets/json/cities.json',
      );
      final List<dynamic> data = json.decode(response);
      allCities.value =
          data.map((city) => EstonianCity.fromJson(city)).toList();
      _setDefaultSelectedCities();
      await loadSelectedCitiesWeather();
    } catch (e) {
      debugPrint("Failed to load cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _setDefaultSelectedCities() {
    if (allCities.length >= 3) {
      selectedCities.value = allCities.take(3).toList();
    } else {
      selectedCities.value = allCities.toList();
    }
  }

  Future<void> loadSelectedCitiesWeather() async {
    try {
      isLoading.value = true;
      List<WeatherModel> weatherList = [];
      List<ForecastModel> mainCityForecast = [];

      for (int i = 0; i < selectedCities.length; i++) {
        final city = selectedCities[i];
        final (weather, forecast) = await getCurrentWeather.call(city.city);
        weatherList.add(weather);
        if (i == mainCityIndex.value) {
          mainCityForecast = forecast;
          forecastData.value = forecast;
        }
      }

      conditionController.updateWeatherData(
        weatherList,
        mainCityIndex.value,
        mainCityName,
      );
      if (mainCityForecast.isNotEmpty) {
        conditionController.updateWeeklyForecast(mainCityForecast);
      }
    } catch (e) {
      debugPrint('Failed to load weather data: $e');
      conditionController.clearWeatherData();
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> getHourlyDataForDate(String date) {
    final forecastDays = rawForecastData['forecast']?['forecastday'] as List?;
    if (forecastDays == null) return [];

    final targetDay = forecastDays.firstWhere(
      (day) => day['date'] == date,
      orElse: () => null,
    );

    if (targetDay != null) {
      final hourlyData = targetDay['hour'] as List;
      return hourlyData
          .map(
            (hour) => {
              'time': hour['time'],
              'temp_c': (hour['temp_c'] as num).toDouble(),
              'condition': hour['condition']['text'],
              'iconUrl': 'https:${hour['condition']['icon']}',
              'humidity': hour['humidity'],
              'wind_kph': (hour['wind_kph'] as num).toDouble(),
              'chance_of_rain': hour['chance_of_rain'],
              'precip_mm': (hour['precip_mm'] as num).toDouble(),
              'feels_like_c': (hour['feelslike_c'] as num).toDouble(),
              'uv': (hour['uv'] as num).toDouble(),
              'pressure_mb': (hour['pressure_mb'] as num).toDouble(),
              'vis_km': (hour['vis_km'] as num).toDouble(),
              'gust_kph': (hour['gust_kph'] as num).toDouble(),
            },
          )
          .toList()
          .cast<Map<String, dynamic>>();
    }

    return [];
  }

  void selectForecastDay(int index) {
    selectedForecastIndex.value = index;
  }

  void updateOtherCityIndex(int index) {
    currentOtherCityIndex.value = index;
  }

  String get mainCityName {
    return selectedCities.isNotEmpty &&
            mainCityIndex.value < selectedCities.length
        ? selectedCities[mainCityIndex.value].city
        : 'Loading...';
  }
}
