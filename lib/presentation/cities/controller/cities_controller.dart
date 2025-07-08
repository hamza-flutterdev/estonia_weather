import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/aqi_model.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../home/controller/home_controller.dart';

class CitiesController extends GetxController {
  final GetWeatherAndForecast getCurrentWeather;
  CitiesController(this.getCurrentWeather);

  final TextEditingController searchController = TextEditingController();
  var allCities = <EstonianCity>[].obs;
  var selectedCities = <EstonianCity>[].obs;
  var allCitiesWeather = <WeatherModel>[].obs;
  var mainCityIndex = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var filteredCities = <EstonianCity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDataFromHome();
    loadAllCitiesWeather();
    _initializeFilteredCities();
  }

  void _initializeFilteredCities() {
    filteredCities.value = allCities.toList();
  }

  void loadDataFromHome() {
    final homeController = Get.find<HomeController>();
    allCities.value = homeController.allCities;
    selectedCities.value = homeController.selectedCities;
    mainCityIndex.value = homeController.mainCityIndex.value;
  }

  Future<void> loadAllCitiesWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      allCitiesWeather.clear();
      print('Loading weather for ${allCities.length} cities');

      final futures =
          allCities.map((city) async {
            try {
              print('Loading weather for: ${city.city}');
              final (weather, _) = await getCurrentWeather.call(city.city);
              print('Successfully loaded weather for: ${city.city}');
              return weather;
            } catch (e) {
              print('Failed to load weather for ${city.city}: $e');
              return WeatherModel(
                cityName: city.city,
                temperature: 0,
                condition: 'No data',
                humidity: 0,
                windSpeed: 0,
                chanceOfRain: 0,
                iconUrl: '',
                airQuality: null,
              );
            }
          }).toList();

      final results = await Future.wait(futures);
      allCitiesWeather.addAll(results);
      print('Total cities weather loaded: ${allCitiesWeather.length}');
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
