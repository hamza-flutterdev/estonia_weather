import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/local_storage/secure_storage.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../reusable/controllers/condtion_controller.dart';

class HomeController extends GetxController {
  final GetCurrentWeather getCurrentWeather;
  final ConditionController conditionController = Get.find();

  HomeController(this.getCurrentWeather);

  final selectedCities = <EstonianCity>[].obs;
  final mainCityIndex = 0.obs;
  final currentDate = ''.obs;
  final isLoading = false.obs;
  final allCities = <EstonianCity>[].obs;
  final selectedForecastIndex = 0.obs;

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
      await loadSelectedCitiesFromStorage();
    } catch (e) {
      debugPrint("Failed to load cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSelectedCitiesFromStorage() async {
    try {
      final String? selectedCitiesJson =
          await StorageService.getSelectedCities();
      final int? mainCityIndexValue = await StorageService.getMainCityIndex();

      if (selectedCitiesJson != null) {
        final List<dynamic> citiesData = json.decode(selectedCitiesJson);
        selectedCities.value =
            citiesData.map((city) => EstonianCity.fromJson(city)).toList();
        if (mainCityIndexValue != null) {
          mainCityIndex.value = mainCityIndexValue;
        }
      } else {
        _setDefaultSelectedCities();
        await saveSelectedCitiesToStorage();
      }
      await loadSelectedCitiesWeather();
    } catch (e) {
      debugPrint('Failed to load selected cities: $e');
    }
  }

  void _setDefaultSelectedCities() {
    if (allCities.length >= 3) {
      selectedCities.value = allCities.take(3).toList();
    } else {
      selectedCities.value = allCities.toList();
    }
  }

  Future<void> saveSelectedCitiesToStorage() async {
    try {
      final String selectedCitiesJson = json.encode(
        selectedCities.map((city) => city.toJson()).toList(),
      );
      await StorageService.setSelectedCities(selectedCitiesJson);
      await StorageService.setMainCityIndex(mainCityIndex.value);
    } catch (e) {
      debugPrint('Failed to save selected cities: $e');
    }
  }

  Future<void> loadSelectedCitiesWeather() async {
    try {
      isLoading.value = true;
      List<WeatherModel> weatherList = [];
      for (final city in selectedCities) {
        final weather = await getCurrentWeather.call(city.city);
        weatherList.add(weather);
      }
      conditionController.updateWeatherData(weatherList, mainCityIndex.value);
    } catch (e) {
      debugPrint('Failed to load weather data: $e');
      conditionController.clearWeatherData();
    } finally {
      isLoading.value = false;
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
}
