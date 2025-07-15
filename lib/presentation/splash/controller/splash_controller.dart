import 'dart:async';
import 'dart:convert';
import 'package:estonia_weather/core/global_service/connectivity_service.dart';
import 'package:estonia_weather/presentation/home/view/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../../gen/assets.gen.dart';

class SplashController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final LocalStorage localStorage = LocalStorage();

  SplashController(this.getCurrentWeather);
  ConditionController get conditionController =>
      Get.find<ConditionController>();
  final isLoading = true.obs;
  final isDataLoaded = false.obs;
  final loadingProgress = 0.0.obs;
  final loadingMessage = 'Initializing...'.obs;
  final allCities = <EstonianCity>[].obs;
  final currentLocationCity = Rx<EstonianCity?>(null);
  final selectedCities = <EstonianCity>[].obs;
  final mainCityIndex = 0.obs;
  final isFirstLaunch = true.obs;
  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 500), () {
      _initWithConnectivityCheck(Get.context!);
    });
  }

  Future<void> _initWithConnectivityCheck(BuildContext context) async {
    debugPrint('[CitiesController] Initializing with connectivity check');

    final hasInternet = await connectivityService.checkInternetWithDialog(
      context,
      onRetry: () => _initWithConnectivityCheck(context),
    );

    if (hasInternet) {
      _initializeApp();
    } else {
      debugPrint(
        '[CitiesController] No internet at startup – retry dialog shown',
      );
    }
  }

  Future<void> _initializeApp() async {
    try {
      isLoading.value = true;
      isDataLoaded.value = false;

      // Step 1: Load cities data
      await _loadAllCities();
      _updateProgress(0.25, 'Loading cities...');

      // Step 2: Check if first launch
      await _checkFirstLaunch();
      _updateProgress(0.5, 'Checking configuration...');

      // Step 3: Get current location
      await _getCurrentLocation();
      _updateProgress(0.75, 'Getting location...');

      // Step 4: Setup cities or load from storage
      if (isFirstLaunch.value) {
        await _setupFirstLaunch();
      } else {
        await _loadSelectedCitiesFromStorage();
      }

      _updateProgress(0.9, 'Loading weather data...');

      // Step 5: Load weather data
      await _loadWeatherData();

      _updateProgress(1.0, 'Ready!');

      // Mark as complete
      isDataLoaded.value = true;
    } catch (e) {
      debugPrint('Error during app initialization: $e');
      // Fallback setup
      await _fallbackSetup();
      isDataLoaded.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void _updateProgress(double progress, String message) {
    loadingProgress.value = progress;
    loadingMessage.value = message;
  }

  Future<void> _loadAllCities() async {
    try {
      final String response = await rootBundle.loadString(
        Assets.database.cities,
      );
      final List<dynamic> data = json.decode(response);
      allCities.value =
          data.map((city) => EstonianCity.fromJson(city)).toList();
    } catch (e) {
      debugPrint("Failed to load cities: $e");
      throw Exception('Failed to load cities data');
    }
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final savedCitiesJson = await localStorage.getString('selected_cities');
      final hasCurrentLocation =
          await localStorage.getBool('has_current_location') ?? false;

      isFirstLaunch.value = savedCitiesJson == null || !hasCurrentLocation;
    } catch (e) {
      debugPrint('Error checking first launch: $e');
      isFirstLaunch.value = true;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final city = await getCurrentWeather.getCity();
      final latStr = await localStorage.getString('latitude');
      final lonStr = await localStorage.getString('longitude');

      double? lat;
      double? lon;

      if (latStr != null && lonStr != null) {
        lat = double.tryParse(latStr);
        lon = double.tryParse(lonStr);
      }

      final foundCity = allCities.firstWhere(
        (c) => c.city.toLowerCase() == city.toLowerCase(),
        orElse: () {
          if (lat != null && lon != null) {
            return EstonianCity(
              city: city,
              cityAscii: city,
              lat: lat,
              lng: lon,
              country: 'Current Location',
              iso2: 'CL',
              iso3: 'CUR',
              adminName: 'Current Location',
              capital: 'primary',
              population: 0,
              id: 999999,
            );
          } else {
            return EstonianCity(
              city: city,
              cityAscii: city,
              lat: 0.0,
              lng: 0.0,
              country: 'Current Location',
              iso2: 'CL',
              iso3: 'CUR',
              adminName: 'Current Location',
              capital: 'primary',
              population: 0,
              id: 999999,
            );
          }
        },
      );

      currentLocationCity.value = foundCity;
    } catch (e) {
      debugPrint('Failed to fetch current location: $e');
      currentLocationCity.value = null;
    }
  }

  Future<void> _setupFirstLaunch() async {
    try {
      // Setup default cities
      final tallinn = allCities.firstWhere(
        (city) => city.city.toLowerCase() == 'tallinn',
        orElse: () => allCities.first,
      );

      final currentCity = currentLocationCity.value;
      final otherCity = allCities.firstWhere(
        (city) =>
            city.city.toLowerCase() != 'tallinn' &&
            city.city.toLowerCase() != currentCity?.city.toLowerCase(),
        orElse: () => allCities.length > 1 ? allCities[1] : allCities.first,
      );

      selectedCities.clear();

      // Add current location as the main city (index 0)
      if (currentCity != null) {
        selectedCities.add(currentCity);
        mainCityIndex.value = 0;
      }

      // Add Tallinn if it's not already the current location
      if (currentCity == null ||
          !selectedCities.any(
            (c) => c.city.toLowerCase() == tallinn.city.toLowerCase(),
          )) {
        selectedCities.add(tallinn);
        // If no current location, make Tallinn the main city
        if (currentCity == null) {
          mainCityIndex.value = selectedCities.length - 1;
        }
      }

      // Add another city if needed
      if (!selectedCities.any(
        (c) => c.city.toLowerCase() == otherCity.city.toLowerCase(),
      )) {
        selectedCities.add(otherCity);
      }

      // Save the setup
      await _saveSelectedCitiesToStorage();
      await localStorage.setBool('has_current_location', currentCity != null);
    } catch (e) {
      debugPrint('Failed to setup first launch: $e');
      await _fallbackSetup();
    }
  }

  Future<void> _loadSelectedCitiesFromStorage() async {
    try {
      final savedCitiesJson = await localStorage.getString('selected_cities');
      final mainCityIdx = await localStorage.getInt('main_city_index') ?? 0;

      if (savedCitiesJson != null) {
        final List<dynamic> savedCitiesData = json.decode(savedCitiesJson);
        final savedCities =
            savedCitiesData.map((e) => EstonianCity.fromJson(e)).toList();

        selectedCities.value =
            savedCities.length >= 2 ? savedCities : allCities.take(2).toList();
        mainCityIndex.value = mainCityIdx.clamp(0, selectedCities.length - 1);
      } else {
        selectedCities.value = allCities.take(2).toList();
        await _saveSelectedCitiesToStorage();
      }
    } catch (e) {
      debugPrint("Failed to load selected cities from storage: $e");
      await _fallbackSetup();
    }
  }

  Future<void> _saveSelectedCitiesToStorage() async {
    try {
      final citiesJson = json.encode(
        selectedCities.map((e) => e.toJson()).toList(),
      );
      await localStorage.setString('selected_cities', citiesJson);
      await localStorage.setInt('main_city_index', mainCityIndex.value);
    } catch (e) {
      debugPrint("Failed to save selected cities to storage: $e");
    }
  }

  Future<void> _fallbackSetup() async {
    try {
      if (allCities.isNotEmpty) {
        selectedCities.value = allCities.take(3).toList();
        mainCityIndex.value = 0;
        await _saveSelectedCitiesToStorage();
      }
    } catch (e) {
      debugPrint('Fallback setup failed: $e');
    }
  }

  void navigateToHome() {
    if (isDataLoaded.value) {
      Get.offAll(HomeView()); // Replace with your home route
    }
  }

  Future<void> _loadWeatherData() async {
    try {
      List<WeatherModel> weatherList = [];
      List<ForecastModel> mainCityForecast = [];
      Map<String, dynamic>? mainCityRawData;

      for (int i = 0; i < selectedCities.length; i++) {
        final city = selectedCities[i];
        try {
          final (weather, forecast) = await getCurrentWeather(
            lat: city.lat,
            lon: city.lng,
          );

          weatherList.add(weather);

          if (i == mainCityIndex.value) {
            mainCityForecast = forecast;
            mainCityRawData = _rawDataStorage[city.city];
          }
        } catch (e) {
          debugPrint('Failed to load weather for ${city.city}: $e');
        }
      }

      // Update condition controller with weather data
      if (weatherList.isNotEmpty) {
        conditionController.updateWeatherData(
          weatherList,
          mainCityIndex.value,
          mainCityName,
        );

        if (mainCityForecast.isNotEmpty) {
          conditionController.updateWeeklyForecast(mainCityForecast);
        }
      }
    } catch (e) {
      debugPrint('Failed to load weather data: $e');
      conditionController.clearWeatherData();
    }
  }

  static void storeRawDataForCity(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }

  String get mainCityName =>
      selectedCities.isNotEmpty && mainCityIndex.value < selectedCities.length
          ? selectedCities[mainCityIndex.value].city
          : 'Loading...';

  // Getters for other controllers to access
  bool get isAppReady => isDataLoaded.value;
  List<EstonianCity> get loadedCities => selectedCities.toList();
  EstonianCity? get currentCity => currentLocationCity.value;
  int get mainIndex => mainCityIndex.value;
  bool get isFirstTime => isFirstLaunch.value;
  Map<String, dynamic> get rawWeatherData =>
      _rawDataStorage[mainCityName] ?? {};
}
