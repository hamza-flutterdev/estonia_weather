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

  final homeController = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();

  static const int maxCities = 10;

  var allCities = <EstonianCity>[].obs;
  var allCitiesWeather = <WeatherModel>[].obs;
  var isLoading = false.obs;
  var isAdding = false.obs;
  var filteredCities = <EstonianCity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDataFromHome();
    loadAllCitiesWeather();
  }

  void loadDataFromHome() {
    // Load all cities (both selected and unselected)
    allCities.value = homeController.allCities;
    filteredCities.value = _getSortedCities();
  }

  void refreshData() {
    loadDataFromHome();
    loadAllCitiesWeather();
  }

  // Sort cities with selected ones at the top
  List<EstonianCity> _getSortedCities() {
    final selectedCities = <EstonianCity>[];
    final unselectedCities = <EstonianCity>[];

    for (final city in allCities) {
      if (homeController.isCitySelected(city)) {
        selectedCities.add(city);
      } else {
        unselectedCities.add(city);
      }
    }

    return [...selectedCities, ...unselectedCities];
  }

  Future<void> loadAllCitiesWeather() async {
    try {
      isLoading.value = true;
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
      debugPrint('Failed to load weather data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchCities(String query) {
    if (query.isEmpty) {
      filteredCities.value = _getSortedCities();
    } else {
      final filtered =
          allCities.where((city) {
            final lowerQuery = query.toLowerCase();
            return city.cityAscii.toLowerCase().contains(lowerQuery) ||
                city.country.toLowerCase().contains(lowerQuery);
          }).toList();

      // Sort filtered results with selected cities first
      final selectedFiltered = <EstonianCity>[];
      final unselectedFiltered = <EstonianCity>[];

      for (final city in filtered) {
        if (homeController.isCitySelected(city)) {
          selectedFiltered.add(city);
        } else {
          unselectedFiltered.add(city);
        }
      }

      filteredCities.value = [...selectedFiltered, ...unselectedFiltered];
    }
  }

  // Methods for adding cities
  bool canAddCity() {
    return homeController.selectedCities.length < maxCities;
  }

  Future<void> addCityToSelected(EstonianCity city) async {
    try {
      isAdding.value = true;
      await homeController.addCityToSelected(city);
      // Refresh the sorted list after adding
      if (searchController.text.isEmpty) {
        filteredCities.value = _getSortedCities();
      } else {
        searchCities(searchController.text);
      }
    } catch (e) {
      debugPrint('Failed to add city: $e');
    } finally {
      isAdding.value = false;
    }
  }

  // Methods for removing cities
  bool canRemoveCity() {
    return homeController.selectedCities.length > 3;
  }

  Future<void> removeCityFromSelected(EstonianCity city) async {
    await homeController.removeCityFromSelected(city);
    // Refresh the sorted list after removing
    if (searchController.text.isEmpty) {
      filteredCities.value = _getSortedCities();
    } else {
      searchCities(searchController.text);
    }
  }

  // Check if city is selected
  bool isCitySelected(EstonianCity city) {
    return homeController.isCitySelected(city);
  }

  String getAqiText(AirQualityModel? airQuality) {
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
