import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../../gen/assets.gen.dart';

class HomeController extends GetxController {
  final GetWeatherAndForecast getCurrentWeather;
  final ConditionController conditionController = Get.find();
  final LocalStorage localStorage = LocalStorage();

  HomeController(this.getCurrentWeather);

  final selectedCities = <EstonianCity>[].obs;
  final allCities = <EstonianCity>[].obs;
  final forecastData = <ForecastModel>[].obs;
  final rawForecastData = <String, dynamic>{}.obs;
  final currentDate = ''.obs;
  final mainCityIndex = 0.obs;
  final selectedForecastIndex = 0.obs;
  final currentOtherCityIndex = 0.obs;
  final isLoading = false.obs;

  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};

  @override
  void onInit() {
    super.onInit();
    _updateCurrentDate();
    _loadAllCities();
    _loadSelectedCitiesFromStorage();
  }

  Future<void> addCityToSelected(EstonianCity city) async {
    if (!selectedCities.any((c) => c.city == city.city)) {
      selectedCities.add(city);
      await _saveSelectedCitiesToStorage();
      await loadSelectedCitiesWeather();
    }
  }

  Future<void> removeCityFromSelected(EstonianCity city) async {
    if (selectedCities.length > 3) {
      selectedCities.removeWhere((c) => c.city == city.city);
      unawaited(_saveSelectedCitiesToStorage());
      unawaited(loadSelectedCitiesWeather());
    }
  }

  bool isCitySelected(EstonianCity city) =>
      selectedCities.any((c) => c.city == city.city);

  Future<void> swapCityWithMainByWeatherModel(WeatherModel weatherModel) async {
    try {
      isLoading.value = true;

      int newMainCityIndex = selectedCities.indexWhere(
        (c) => c.cityAscii.toLowerCase() == weatherModel.cityName.toLowerCase(),
      );

      if (newMainCityIndex == -1) {
        final citiesWeather = conditionController.selectedCitiesWeather;
        newMainCityIndex = citiesWeather.indexWhere(
          (w) =>
              w.cityName.toLowerCase() == weatherModel.cityName.toLowerCase(),
        );
      }

      if (newMainCityIndex >= 0 && newMainCityIndex != mainCityIndex.value) {
        mainCityIndex.value = newMainCityIndex;
        await _saveSelectedCitiesToStorage();
        await loadSelectedCitiesWeather();
      }
    } catch (e) {
      debugPrint('Failed to change main city: $e');
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
      final hourly = targetDay['hour'] as List;
      return hourly
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
          .toList();
    }
    return [];
  }

  void selectForecastDay(int index) => selectedForecastIndex.value = index;
  void updateOtherCityIndex(int index) => currentOtherCityIndex.value = index;

  String get mainCityName =>
      selectedCities.isNotEmpty && mainCityIndex.value < selectedCities.length
          ? selectedCities[mainCityIndex.value].city
          : 'Loading...';

  void _updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat('EEEE dd MMMM').format(now);
  }

  Future<void> _loadAllCities() async {
    try {
      isLoading.value = true;
      final String response = await rootBundle.loadString(
        Assets.database.cities,
      );
      final List<dynamic> data = json.decode(response);
      allCities.value =
          data.map((city) => EstonianCity.fromJson(city)).toList();
    } catch (e) {
      debugPrint("Failed to load cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSelectedCitiesFromStorage() async {
    try {
      final savedCitiesJson = await localStorage.getString('selected_cities');
      if (savedCitiesJson != null) {
        final List<dynamic> savedCitiesData = json.decode(savedCitiesJson);
        final savedCities =
            savedCitiesData.map((e) => EstonianCity.fromJson(e)).toList();
        selectedCities.value =
            savedCities.length >= 3 ? savedCities : allCities.take(3).toList();
      } else {
        selectedCities.value = allCities.take(3).toList();
        await _saveSelectedCitiesToStorage();
      }
      await loadSelectedCitiesWeather();
    } catch (e) {
      debugPrint("Failed to load selected cities from storage: $e");
      selectedCities.value = allCities.take(3).toList();
      await _saveSelectedCitiesToStorage();
      await loadSelectedCitiesWeather();
    }
  }

  Future<void> _saveSelectedCitiesToStorage() async {
    try {
      final citiesJson = json.encode(
        selectedCities.map((e) => e.toJson()).toList(),
      );
      await localStorage.setString('selected_cities', citiesJson);
    } catch (e) {
      debugPrint("Failed to save selected cities to storage: $e");
    }
  }

  Future<void> loadSelectedCitiesWeather() async {
    try {
      isLoading.value = true;
      List<WeatherModel> weatherList = [];
      List<ForecastModel> mainCityForecast = [];
      Map<String, dynamic>? mainCityRawData;

      for (int i = 0; i < selectedCities.length; i++) {
        final city = selectedCities[i];
        final (weather, forecast) = await getCurrentWeather(
          lat: city.lat,
          lon: city.lng,
        );
        weatherList.add(weather);

        if (i == mainCityIndex.value) {
          mainCityForecast = forecast;
          forecastData.value = forecast;
          mainCityRawData = _rawDataStorage[city.city];
        }
      }

      if (mainCityRawData != null) {
        rawForecastData.value = mainCityRawData;
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

  static void storeRawDataForCity(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }
}
