import 'dart:async';

import 'package:get/get.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import 'home_controller_helper.dart';

class HomeController extends GetxController {
  final GetWeatherAndForecast getCurrentWeather;
  final ConditionController conditionController = Get.find();
  final LocalStorage localStorage = LocalStorage();

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
    updateCurrentDate();
    loadAllCities();
    loadSelectedCitiesFromStorage();
  }

  void updateCurrentDate() =>
      HomeControllerHelpers.updateCurrentDate(currentDate);
  Future<void> loadAllCities() =>
      HomeControllerHelpers.loadAllCities(allCities, isLoading);
  Future<void> loadSelectedCitiesFromStorage() =>
      HomeControllerHelpers.loadSelectedCitiesFromStorage(
        allCities,
        selectedCities,
        localStorage,
        _saveSelectedCitiesToStorage,
        loadSelectedCitiesWeather,
      );

  Future<void> _saveSelectedCitiesToStorage() =>
      HomeControllerHelpers.saveSelectedCitiesToStorage(
        selectedCities,
        localStorage,
      );

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

  Future<void> loadSelectedCitiesWeather() =>
      HomeControllerHelpers.loadSelectedCitiesWeather(
        selectedCities,
        getCurrentWeather,
        mainCityIndex,
        forecastData,
        isLoading,
        conditionController,
        mainCityName,
      );

  Future<void> swapCityWithMainByWeatherModel(WeatherModel weatherModel) =>
      HomeControllerHelpers.swapCityWithMainByWeatherModel(
        weatherModel,
        selectedCities,
        mainCityIndex,
        _saveSelectedCitiesToStorage,
        loadSelectedCitiesWeather,
        conditionController,
        isLoading,
      );

  List<Map<String, dynamic>> getHourlyDataForDate(String date) =>
      HomeControllerHelpers.getHourlyDataForDate(date, rawForecastData);

  void selectForecastDay(int index) => selectedForecastIndex.value = index;
  void updateOtherCityIndex(int index) => currentOtherCityIndex.value = index;

  String get mainCityName =>
      selectedCities.isNotEmpty && mainCityIndex.value < selectedCities.length
          ? selectedCities[mainCityIndex.value].city
          : 'Loading...';
}
