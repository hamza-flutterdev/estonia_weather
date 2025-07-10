import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/aqi_model.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../home/controller/home_controller.dart';

class SelectCityController extends GetxController {
  final GetWeatherAndForecast getCurrentWeather;
  SelectCityController(this.getCurrentWeather);

  final homeController = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();

  var allCities = <EstonianCity>[].obs;
  var allCitiesWeather = <WeatherModel>[].obs;
  var isLoading = false.obs;
  var isAdding = false.obs;
  var errorMessage = ''.obs;
  var filteredCities = <EstonianCity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDataFromHome();
    loadAllCitiesWeather();
  }

  void loadDataFromHome() {
    allCities.value = homeController.allCities;
    filteredCities.value = allCities.toList();
  }

  Future<void> loadAllCitiesWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      allCitiesWeather.clear();
      final futures =
          allCities.map((city) async {
            try {
              final (weather, _) = await getCurrentWeather.call(
                lat: city.lat,
                lon: city.lng,
              );
              return weather;
            } catch (e) {
              debugPrint('Failed to load weather for ${city.city}: $e');
              return WeatherModel(
                cityName: city.city,
                temperature: 0,
                condition: 'No data',
                humidity: 0,
                windSpeed: 0,
                chanceOfRain: 0,
                iconUrl: '',
                airQuality: null,
                code: 0,
              );
            }
          }).toList();
      final results = await Future.wait(futures);
      allCitiesWeather.addAll(results);
    } catch (e) {
      errorMessage.value = 'Failed to load weather data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void searchCities(String query) {
    if (query.isEmpty) {
      filteredCities.value = allCities.toList();
    } else {
      filteredCities.value =
          allCities.where((city) {
            final lowerQuery = query.toLowerCase();
            return city.cityAscii.toLowerCase().contains(lowerQuery) ||
                city.country.toLowerCase().contains(lowerQuery);
          }).toList();
    }
  }

  Future<void> addCityToSelected(EstonianCity city) async {
    try {
      isAdding.value = true;
      await homeController.addCityToSelected(city);
    } catch (e) {
      debugPrint('Failed to add city: $e');
    } finally {
      isAdding.value = false;
    }
  }

  bool isCitySelected(EstonianCity city) {
    return homeController.isCitySelected(city);
  }

  String getAirQualityText(AirQualityModel? airQuality) {
    if (airQuality == null) return 'Air quality unavailable';
    final aqi = airQuality.calculatedAqi;
    final category = airQuality.getAirQualityCategory(aqi);
    return 'AQI $aqi – $category';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
