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

  static const int maxCities = 5;
  static const int minCities = 3;

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
    _initWithConnectivityCheck(Get.context!);
    searchController.addListener(() {
      searchCities(searchController.text);
    });
  }

  Future<void> _initWithConnectivityCheck(BuildContext context) async {
    debugPrint('[CitiesController] Initializing with connectivity check');

    final hasInternet = await connectivityService.checkInternetWithDialog(
      context,
      onRetry: () => _initWithConnectivityCheck(context),
    );

    loadDataFromHome();

    if (hasInternet) {
      await loadAllCitiesWeather();
    } else {
      debugPrint(
        '[CitiesController] No internet at startup – retry dialog shown',
      );
    }
  }

  @override
  void onInternetConnected() {
    super.onInternetConnected();
    debugPrint(
      '[CitiesController] Internet connected — waiting for user retry',
    );
  }

  @override
  void onInternetDisconnected() {
    super.onInternetDisconnected();
    debugPrint('[CitiesController] Internet disconnected');
  }

  void loadDataFromHome() {
    allCities.value = homeController.allCities;
    filteredCities.value = _getSortedCities();
  }

  void refreshData() {
    loadDataFromHome();
    loadAllCitiesWeather();
  }

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
      hasSearchError.value = false;
      searchErrorMessage.value = '';
    } else {
      final lowerQuery = query.toLowerCase();
      final filtered =
          allCities.where((city) {
            return city.cityAscii.toLowerCase().contains(lowerQuery) ||
                city.country.toLowerCase().contains(lowerQuery);
          }).toList();

      if (filtered.isEmpty) {
        hasSearchError.value = true;
        searchErrorMessage.value = 'No cities found matching "$query"';
      } else {
        hasSearchError.value = false;
        searchErrorMessage.value = '';
      }

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

  bool canAddCity() {
    return homeController.selectedCities.length < maxCities;
  }

  Future<void> addCityToSelected(EstonianCity city) async {
    try {
      isAdding.value = true;
      await homeController.addCityToSelected(city);
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

  // in this function there is messy code make this short
  // or create a separate file for messages switch statement will cover this

  Future<void> addCurrentLocationToSelected(BuildContext context) async {
    try {
      isAdding.value = true;

      final cityName = await getCurrentWeather.getCity();

      final latStr = await homeController.localStorage.getString('latitude');
      final lonStr = await homeController.localStorage.getString('longitude');
      final lat = latStr != null ? double.tryParse(latStr) : null;
      final lon = lonStr != null ? double.tryParse(lonStr) : null;

      await homeController.setCurrentLocationCity(
        cityName: cityName,
        lat: lat,
        lon: lon,
      );

      if (homeController.currentLocationCity != null) {
        await homeController.addCurrentLocationToSelectedAsMain();
        loadDataFromHome();

        if (searchController.text.isNotEmpty) {
          searchCities(searchController.text);
        }

        SimpleToast.showCustomToast(
          context: context,
          message: 'Current location is now the main city',
          type: ToastificationType.success,
          primaryColor: primaryColor,
          icon: Icons.location_on,
        );
      } else {
        SimpleToast.showCustomToast(
          context: context,
          message: 'Failed to detect your current location. Try again later.',
          type: ToastificationType.error,
          primaryColor: kRed,
          icon: Icons.error_outline,
        );
        debugPrint('Current location city is null after permission check');
      }
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();

      String userMessage;
      if (errorMessage.contains('permanently denied')) {
        userMessage =
            'Location access is permanently denied. Please enable it in app settings.';
      } else if (errorMessage.contains('denied')) {
        userMessage =
            'Location permission denied. Please allow access to use your current location.';
      } else if (errorMessage.contains('services are disabled')) {
        userMessage = 'Location services are disabled. Please enable them.';
      } else if (errorMessage.contains('timed out')) {
        userMessage = 'Location request timed out. Please try again.';
      } else {
        userMessage = 'Failed to get current location. Please try again.';
      }

      SimpleToast.showCustomToast(
        context: context,
        message: userMessage,
        type: ToastificationType.error,
        primaryColor: kRed,
        icon: Icons.error_outline,
      );

      debugPrint('Failed to add current location: $e');
    } finally {
      isAdding.value = false;
    }
  }

  bool canRemoveCity() {
    return homeController.selectedCities.length > minCities;
  }

  bool canRemoveSpecificCity(EstonianCity city) {
    if (homeController.isCurrentLocationCity(city)) {
      return false;
    }
    return canRemoveCity();
  }

  Future<void> removeCityFromSelected(EstonianCity city) async {
    if (canRemoveSpecificCity(city)) {
      await homeController.removeCityFromSelected(city);
      loadDataFromHome();
      if (searchController.text.isNotEmpty) {
        searchCities(searchController.text);
      }
    }
  }

  bool isCitySelected(EstonianCity city) {
    return homeController.isCitySelected(city);
  }

  bool isCurrentLocationCity(EstonianCity city) {
    return homeController.isCurrentLocationCity(city);
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
