import 'package:estonia_weather/core/common/app_exceptions.dart';
import 'package:estonia_weather/core/global_service/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/custom_toast.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/model/aqi_model.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../home/controller/home_controller.dart';

class CitiesController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  CitiesController(this.getCurrentWeather);

  final homeController = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();
  var allCities = <EstonianCity>[].obs;
  var allCitiesWeather = <WeatherModel>[].obs;
  var isLoading = false.obs;
  var isAdding = false.obs;
  var filteredCities = <EstonianCity>[].obs;
  var hasSearchError = false.obs;
  var searchErrorMessage = ''.obs;

  @override
  void onReady() {
    super.onReady();
    initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async {
        loadDataFromHome();
        await loadAllCitiesWeather();
      },
    );
    searchController.addListener(() {
      searchCities(searchController.text);
    });
  }

  void loadDataFromHome() {
    allCities.value = homeController.allCities;
    filteredCities.value = _getSortedCities();
  }

  List<EstonianCity> _getSortedCities() {
    final selectedCities = <EstonianCity>[];
    final unselectedCities = <EstonianCity>[];

    for (final city in allCities) {
      if (homeController.isSelected(city)) {
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
              return WeatherModel.empty(city.city);
            }
          }).toList();

      final results = await Future.wait(futures);
      allCitiesWeather.addAll(results);
    } catch (e) {
      debugPrint('$failedLoadingWeather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchCities(String query) {
    final lowerQuery = query.toLowerCase();

    final results =
        query.isEmpty
            ? _getSortedCities()
            : allCities
                .where(
                  (city) =>
                      city.cityAscii.toLowerCase().contains(lowerQuery) ||
                      city.country.toLowerCase().contains(lowerQuery),
                )
                .toList();

    hasSearchError.value = results.isEmpty && query.isNotEmpty;
    searchErrorMessage.value =
        hasSearchError.value ? '$noCityFound "$query"' : '';

    if (query.isEmpty || results.isEmpty) {
      filteredCities.value = results;
      return;
    }

    final selectedFiltered = results.where(
      (city) => homeController.isSelected(city),
    );
    final unselectedFiltered = results.where(
      (city) => !homeController.isSelected(city),
    );

    filteredCities.value = [...selectedFiltered, ...unselectedFiltered];
  }

  Future<void> addCityToSelected(EstonianCity city) async {
    try {
      isAdding.value = true;
      await homeController.addCity(city);
      loadDataFromHome();
      if (searchController.text.isNotEmpty) {
        searchCities(searchController.text);
      }
    } catch (e) {
      debugPrint('Failed to add city: $e');
    } finally {
      isAdding.value = false;
    }
  }

  Future<void> addCurrentLocationToSelected(BuildContext context) async {
    void showToast(String message, bool success) {
      SimpleToast.showCustomToast(
        context: context,
        message: message,
        type: success ? ToastificationType.success : ToastificationType.error,
        primaryColor: success ? primaryColor : kRed,
        icon: success ? Icons.location_on : Icons.error_outline,
      );
    }

    isAdding.value = true;

    try {
      final cityName = await getCurrentWeather.getCity();
      final lat = double.tryParse(
        await homeController.localStorage.getString('latitude') ?? '',
      );
      final lon = double.tryParse(
        await homeController.localStorage.getString('longitude') ?? '',
      );
      await homeController.setLocationCity(
        cityName: cityName,
        lat: lat,
        lon: lon,
      );
      final success = homeController.currentLocationCity != null;
      if (success) {
        await homeController.addLocationAsMain();
        loadDataFromHome();
        if (searchController.text.isNotEmpty) {
          searchCities(searchController.text);
        }
      }
      showToast(success ? successCityChange : failedLocation, success);
    } catch (e) {
      final error = e.toString().toLowerCase();
      final message =
          error.contains('denied') || error.contains('services are disabled')
              ? deniedPermission
              : error.contains('timed out')
              ? timeoutException
              : failedLocation;

      showToast(message, false);
      debugPrint('$failedCityChange: $e');
    } finally {
      isAdding.value = false;
    }
  }

  bool canRemoveSpecificCity(EstonianCity city) {
    if (homeController.isLocationCity(city)) {
      return false;
    }
    return homeController.selectedCities.length > 3;
  }

  Future<void> removeCityFromSelected(EstonianCity city) async {
    if (canRemoveSpecificCity(city)) {
      await homeController.removeCity(city);
      loadDataFromHome();
      if (searchController.text.isNotEmpty) {
        searchCities(searchController.text);
      }
    }
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
