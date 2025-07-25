import 'dart:async';
import 'dart:convert';
import 'package:estonia_weather/presentation/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/global_service/connectivity_service.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../cities/controller/cities_controller.dart';

class HomeController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final ConditionController conditionController = Get.find();
  final LocalStorage localStorage = LocalStorage();

  HomeController(this.getCurrentWeather);

  final _selectedCities = <EstonianCity>[].obs;
  final _mainCityIndex = 0.obs;
  final _currentLocationCity = Rx<EstonianCity?>(null);
  final _isFirstLaunch = true.obs;
  final currentLocation = ''.obs;
  final forecastData = <ForecastModel>[].obs;
  final rawForecastData = <String, dynamic>{}.obs;
  final currentDate = ''.obs;
  final selectedForecastIndex = 0.obs;
  final currentOtherCityIndex = 0.obs;
  final isLoading = false.obs;

  // Connectivity-related reactive variables
  final needsDataRefresh = false.obs;
  final lastDataFetch = Rx<DateTime?>(null);

  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};

  // Getters
  EstonianCity? get currentLocationCity => _currentLocationCity.value;
  List<EstonianCity> get selectedCities => _selectedCities.toList();
  List<EstonianCity> get allCities {
    final splashController = Get.find<SplashController>();
    return splashController.allCities.toList();
  }

  int get mainCityIndex => _mainCityIndex.value;
  bool get isFirstLaunch => _isFirstLaunch.value;

  @override
  void onInit() {
    super.onInit(); // This will call ConnectivityMixin.onInit()

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));

      _updateCurrentDate();
      _initializeSafely();

      if (connectivityService.isConnected) {
        await _refreshDataIfNeeded();
      }
    });
  }

  @override
  void onInternetConnected() {
    super.onInternetConnected();

    _refreshDataIfNeeded();
  }

  @override
  void onInternetDisconnected() {
    super.onInternetDisconnected();
    needsDataRefresh.value = true;
  }

  Future<void> _refreshDataIfNeeded() async {
    final now = DateTime.now();
    final shouldRefresh =
        lastDataFetch.value == null ||
        now.difference(lastDataFetch.value!).inMinutes > 10 ||
        needsDataRefresh.value;

    if (shouldRefresh && connectivityService.isConnected) {
      debugPrint(
        '[HomeController] Refreshing data due to connectivity or time',
      );
      await loadSelectedCitiesWeather();
      needsDataRefresh.value = false;
      lastDataFetch.value = now;
    }
  }

  void _initializeSafely() {
    final splashController = Get.find<SplashController>();
    _syncWithSplashController();

    ever(splashController.isDataLoaded, (bool isLoaded) {
      if (isLoaded) {
        _syncWithSplashController();
        _initializeWeatherData();
      }
    });

    if (splashController.isAppReady) {
      _initializeWeatherData();
    }
  }

  void _syncWithSplashController() {
    final splashController = Get.find<SplashController>();
    _selectedCities.value = splashController.selectedCities.toList();
    _mainCityIndex.value = splashController.mainCityIndex.value;
    _currentLocationCity.value = splashController.currentLocationCity.value;
    _isFirstLaunch.value = splashController.isFirstLaunch.value;
  }

  Future<void> _initializeWeatherData() async {
    try {
      currentLocation.value = currentLocationCity?.city ?? 'Unknown';

      // Only load weather if we have internet
      if (connectivityService.isConnected) {
        await loadSelectedCitiesWeather();
      } else {
        debugPrint('[HomeController] No internet - skipping weather data load');
      }
    } catch (e) {
      debugPrint('Error initializing weather data: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    currentLocation.value = currentLocationCity?.city ?? 'Unknown';
  }

  Future<void> addCurrentLocationToSelectedAsMain() async {
    if (currentLocationCity != null) {
      final updatedCities = List<EstonianCity>.from(_selectedCities);
      if (!isCitySelected(currentLocationCity!)) {
        updatedCities.insert(0, currentLocationCity!);
        if (updatedCities.length > CitiesController.maxCities) {
          updatedCities.removeLast();
        }
      } else {
        updatedCities.removeWhere(
          (city) => city.city == currentLocationCity!.city,
        );
        updatedCities.insert(0, currentLocationCity!);
      }

      _selectedCities.value = updatedCities;
      _mainCityIndex.value = 0;
      await _saveSelectedCitiesToStorage();
      await _updateSplashController();

      // Use connectivity-aware loading
      await _loadWeatherWithConnectivityCheck();
    }
  }

  Future<void> addCityToSelected(EstonianCity city) async {
    if (!isCitySelected(city)) {
      final updatedCities = List<EstonianCity>.from(_selectedCities);
      updatedCities.add(city);
      _selectedCities.value = updatedCities;
      await _saveSelectedCitiesToStorage();
      await _updateSplashController();

      // Use connectivity-aware loading
      await _loadWeatherWithConnectivityCheck();
    }
  }

  Future<void> removeCityFromSelected(EstonianCity city) async {
    if (currentLocationCity != null && city.city == currentLocationCity!.city) {
      return;
    }

    if (_selectedCities.length > 2) {
      final updatedCities = List<EstonianCity>.from(_selectedCities);
      updatedCities.removeWhere((c) => c.city == city.city);
      _selectedCities.value = updatedCities;

      if (_mainCityIndex.value >= updatedCities.length) {
        _mainCityIndex.value = updatedCities.length - 1;
      }

      unawaited(_saveSelectedCitiesToStorage());
      unawaited(_updateSplashController());

      // Use connectivity-aware loading
      unawaited(_loadWeatherWithConnectivityCheck());
    }
  }

  // Connectivity-aware weather loading
  Future<void> _loadWeatherWithConnectivityCheck() async {
    await ensureInternetConnection(
      action: () async {
        await loadSelectedCitiesWeather();
      },
      context: Get.context,
    );
  }

  bool isCitySelected(EstonianCity city) =>
      _selectedCities.any((c) => c.city == city.city);

  bool isCurrentLocationCity(EstonianCity city) =>
      currentLocationCity != null && city.city == currentLocationCity!.city;

  Future<void> addCurrentLocationToSelected() async {
    if (currentLocationCity != null && !isCitySelected(currentLocationCity!)) {
      final updatedCities = List<EstonianCity>.from(_selectedCities);
      updatedCities.insert(0, currentLocationCity!);
      _selectedCities.value = updatedCities;
      _mainCityIndex.value = _mainCityIndex.value + 1;
      await _saveSelectedCitiesToStorage();
      await _updateSplashController();

      // Use connectivity-aware loading
      await _loadWeatherWithConnectivityCheck();
    }
  }

  Future<void> swapCityWithMainByWeatherModel(WeatherModel weatherModel) async {
    try {
      isLoading.value = true;

      int newMainCityIndex = _selectedCities.indexWhere(
        (c) => c.cityAscii.toLowerCase() == weatherModel.cityName.toLowerCase(),
      );

      if (newMainCityIndex == -1) {
        final citiesWeather = conditionController.selectedCitiesWeather;
        newMainCityIndex = citiesWeather.indexWhere(
          (w) =>
              w.cityName.toLowerCase() == weatherModel.cityName.toLowerCase(),
        );
      }

      if (newMainCityIndex >= 0 && newMainCityIndex != _mainCityIndex.value) {
        _mainCityIndex.value = newMainCityIndex;
        await _saveSelectedCitiesToStorage();
        await _updateSplashController();

        // Use connectivity-aware loading
        await _loadWeatherWithConnectivityCheck();
      }
    } catch (e) {
      debugPrint('Failed to change main city: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to manually refresh data (for pull-to-refresh)
  Future<void> refreshWeatherData() async {
    await ensureInternetConnection(
      action: () async {
        await loadSelectedCitiesWeather();
        lastDataFetch.value = DateTime.now();
      },
      context: Get.context,
    );
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
      _selectedCities.isNotEmpty &&
              _mainCityIndex.value < _selectedCities.length
          ? _selectedCities[_mainCityIndex.value].city
          : 'Loading...';

  void _updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat('EEEE dd MMMM').format(now);
  }

  Future<void> _saveSelectedCitiesToStorage() async {
    try {
      final citiesJson = json.encode(
        _selectedCities.map((e) => e.toJson()).toList(),
      );
      await localStorage.setString('selected_cities', citiesJson);
      await localStorage.setInt('main_city_index', _mainCityIndex.value);
    } catch (e) {
      debugPrint("Failed to save selected cities to storage: $e");
    }
  }

  Future<void> _updateSplashController() async {
    try {
      final splashController = Get.find<SplashController>();
      splashController.selectedCities.value = _selectedCities.toList();
      splashController.mainCityIndex.value = _mainCityIndex.value;
    } catch (e) {
      debugPrint('Error updating splash controller: $e');
    }
  }

  Future<void> loadSelectedCitiesWeather() async {
    // Skip if no internet connection
    if (!connectivityService.isConnected) {
      debugPrint('[HomeController] No internet - skipping weather load');
      return;
    }

    try {
      isLoading.value = true;
      List<WeatherModel> weatherList = [];
      List<ForecastModel> mainCityForecast = [];
      Map<String, dynamic>? mainCityRawData;

      for (int i = 0; i < _selectedCities.length; i++) {
        final city = _selectedCities[i];
        try {
          final (weather, forecast) = await getCurrentWeather(
            lat: city.lat,
            lon: city.lng,
          );

          weatherList.add(weather);

          if (i == _mainCityIndex.value) {
            mainCityForecast = forecast;
            forecastData.value = forecast;
            mainCityRawData = _rawDataStorage[city.city];
          }
        } catch (e) {
          debugPrint('Failed to load weather for ${city.city}: $e');
        }
      }

      if (mainCityRawData != null) {
        rawForecastData.value = mainCityRawData;
      }

      if (weatherList.isNotEmpty) {
        conditionController.updateWeatherData(
          weatherList,
          _mainCityIndex.value,
          mainCityName,
        );

        if (mainCityForecast.isNotEmpty) {
          conditionController.updateWeeklyForecast(mainCityForecast);
        }
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
