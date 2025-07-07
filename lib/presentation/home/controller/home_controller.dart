import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../reusable/controllers/condition_controller.dart';

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

      // Update condition controller with weather data
      conditionController.updateWeatherData(
        weatherList,
        mainCityIndex.value,
        mainCityName,
      );

      // Update condition controller with forecast data
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

  // Method to change main city
  Future<void> changeMainCity(int newIndex) async {
    if (newIndex >= 0 && newIndex < selectedCities.length) {
      mainCityIndex.value = newIndex;
      await loadSelectedCitiesWeather(); // Reload to get forecast for new main city
    }
  }

  // Method to add a new city
  Future<void> addCity(EstonianCity city) async {
    if (!selectedCities.contains(city)) {
      selectedCities.add(city);
      await loadSelectedCitiesWeather();
    }
  }

  // Method to remove a city
  Future<void> removeCity(int index) async {
    if (index >= 0 && index < selectedCities.length) {
      selectedCities.removeAt(index);
      // Adjust main city index if needed
      if (mainCityIndex.value >= selectedCities.length) {
        mainCityIndex.value = selectedCities.length - 1;
      }
      if (selectedCities.isNotEmpty) {
        await loadSelectedCitiesWeather();
      } else {
        conditionController.clearWeatherData();
      }
    }
  }

  void selectForecastDay(int index) {
    selectedForecastIndex.value = index;
  }

  String get mainCityName {
    return selectedCities.isNotEmpty &&
            mainCityIndex.value < selectedCities.length
        ? selectedCities[mainCityIndex.value].city
        : 'Loading...';
  }

  // Refresh weather data
  Future<void> refreshWeatherData() async {
    await loadSelectedCitiesWeather();
  }
}
