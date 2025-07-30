import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:estonia_weather/core/common/app_exceptions.dart';
import 'package:estonia_weather/presentation/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/global_service/android_widget_service.dart';
import '../../../core/global_service/connectivity_service.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';

class HomeController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final ConditionController conditionController = Get.find();
  final LocalStorage localStorage = LocalStorage();
  final splashController = Get.find<SplashController>();

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
  final isDrawerOpen = false.obs;
  final needsDataRefresh = false.obs;
  final lastDataFetch = Rx<DateTime?>(null);

  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};

  EstonianCity? get currentLocationCity => _currentLocationCity.value;
  List<EstonianCity> get selectedCities => _selectedCities.toList();
  List<EstonianCity> get allCities => splashController.allCities.toList();
  int get mainCityIndex => _mainCityIndex.value;
  bool get isFirstLaunch => _isFirstLaunch.value;
  String get mainCityName =>
      selectedCities.isNotEmpty && _mainCityIndex.value < selectedCities.length
          ? selectedCities[_mainCityIndex.value].city
          : 'Loading...';

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 100));
    WidgetUpdaterService.setupMethodChannelHandler();
    WidgetUpdateManager.startPeriodicUpdate();
    _updateDate();
    _safeInit();
    if (connectivityService.isConnected) {
      await _refreshIfStale();
    }
  }

  Future<void> requestTrackingPermission() async {
    if (!Platform.isIOS) return;
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    debugPrint('Tracking status: $status');
  }

  void _safeInit() {
    _syncSplash();
    ever(splashController.isDataLoaded, (isLoaded) {
      if (isLoaded) {
        _syncSplash();
        _initWeather();
      }
    });

    if (splashController.isAppReady) {
      _initWeather();
    }
  }

  void _syncSplash() {
    _selectedCities.value = splashController.selectedCities.toList();
    _mainCityIndex.value = splashController.mainCityIndex.value;
    _currentLocationCity.value = splashController.currentLocationCity.value;
    _isFirstLaunch.value = splashController.isFirstLaunch.value;
  }

  Future<void> _refreshIfStale() async {
    final now = DateTime.now();
    final shouldRefresh =
        lastDataFetch.value == null ||
        now.difference(lastDataFetch.value!).inMinutes > 10 ||
        needsDataRefresh.value;

    if (!shouldRefresh || !connectivityService.isConnected) return;

    await loadSelectedWeather();
    needsDataRefresh.value = false;
    lastDataFetch.value = now;
  }

  Future<void> _initWeather() async {
    currentLocation.value = currentLocationCity?.city ?? 'Unknown';
    if (connectivityService.isConnected) {
      await loadSelectedWeather();
    } else {
      debugPrint(noInternet);
    }
  }

  Future<void> setLocationCity({
    required String cityName,
    double? lat,
    double? lon,
  }) async {
    final match = allCities.firstWhereOrNull(
      (city) => city.city.toLowerCase() == cityName.toLowerCase(),
    );

    final city = match ?? EstonianCity.fallback(cityName, lat: lat, lon: lon);
    _currentLocationCity.value = city;
    currentLocation.value = city.city;
  }

  Future<void> fetchLocation() async {
    currentLocation.value = currentLocationCity?.city ?? 'Unknown';
  }

  Future<void> addCity(EstonianCity city) async {
    if (isSelected(city)) return;
    _selectedCities.add(city);
    await _afterCityChange();
  }

  Future<void> removeCity(EstonianCity city) async {
    if (isLocationCity(city) || _selectedCities.length <= 2) return;
    _selectedCities.removeWhere((c) => c.city == city.city);
    _mainCityIndex.value = _mainCityIndex.value.clamp(
      0,
      _selectedCities.length - 1,
    );
    unawaited(_afterCityChange());
  }

  Future<void> addLocationCity() async {
    if (currentLocationCity == null || isSelected(currentLocationCity!)) return;
    _selectedCities.insert(0, currentLocationCity!);
    await _afterCityChange();
  }

  Future<void> addLocationAsMain() async {
    if (currentLocationCity == null) return;

    final city = currentLocationCity!;
    final updated = List<EstonianCity>.from(_selectedCities)
      ..removeWhere((c) => c.city == city.city);
    updated.insert(0, city);

    if (updated.length > 5) updated.removeLast();

    _selectedCities.value = updated;
    _mainCityIndex.value = 0;
    await _afterCityChange();
  }

  Future<void> makeCityMain(WeatherModel model) async {
    isLoading.value = true;

    int index = _selectedCities.indexWhere(
      (c) => c.cityAscii.toLowerCase() == model.cityName.toLowerCase(),
    );

    if (index == -1) {
      index = conditionController.selectedCitiesWeather.indexWhere(
        (w) => w.cityName.toLowerCase() == model.cityName.toLowerCase(),
      );
    }

    if (index >= 0 && index != _mainCityIndex.value) {
      _mainCityIndex.value = index;
      await _afterCityChange();
    }

    isLoading.value = false;
  }

  Future<void> makeCityMainByIndex(int index) async {
    if (index < 0 ||
        index >= _selectedCities.length ||
        index == _mainCityIndex.value)
      return;
    isLoading.value = true;
    _mainCityIndex.value = index;
    await _afterCityChange();
    isLoading.value = false;
  }

  Future<void> _afterCityChange() async {
    await _storeSelectedCities();
    await _updateSplashController();
    await _loadWeatherSafe();
  }

  Future<void> _loadWeatherSafe() async {
    await ensureInternetConnection(
      action: loadSelectedWeather,
      context: Get.context,
    );
  }

  bool isSelected(EstonianCity city) =>
      _selectedCities.any((c) => c.city == city.city);

  bool isLocationCity(EstonianCity city) =>
      currentLocationCity?.city == city.city;

  Future<void> loadSelectedWeather() async {
    if (!connectivityService.isConnected) return;

    isLoading.value = true;
    final weatherList = <WeatherModel>[];
    List<ForecastModel> mainForecast = [];
    Map<String, dynamic>? rawData;

    for (int i = 0; i < _selectedCities.length; i++) {
      final city = _selectedCities[i];
      try {
        final (weather, forecast) = await getCurrentWeather(
          lat: city.lat,
          lon: city.lng,
        );

        weatherList.add(weather);
        if (i == _mainCityIndex.value) {
          mainForecast = forecast;
          forecastData.value = forecast;
          rawData = _rawDataStorage[city.city];
        }
      } catch (e) {
        debugPrint('$failedLoadingWeather ${city.city}: $e');
      }
    }

    if (rawData != null) {
      rawForecastData.value = rawData;
    }

    if (weatherList.isNotEmpty) {
      conditionController.updateWeatherData(
        weatherList,
        _mainCityIndex.value,
        mainCityName,
      );

      if (mainForecast.isNotEmpty) {
        conditionController.updateWeeklyForecast(mainForecast);
      }
    } else {
      conditionController.clearWeatherData();
    }

    isLoading.value = false;
  }

  Future<void> _storeSelectedCities() async {
    try {
      final citiesJson = json.encode(
        _selectedCities.map((e) => e.toJson()).toList(),
      );
      await localStorage.setString('selected_cities', citiesJson);
      await localStorage.setInt('main_city_index', _mainCityIndex.value);
    } catch (e) {
      debugPrint("$failToSave: $e");
    }
  }

  Future<void> _updateSplashController() async {
    splashController.selectedCities.value = _selectedCities.toList();
    splashController.mainCityIndex.value = _mainCityIndex.value;
  }

  List<Map<String, dynamic>> hourlyForDate(String date) {
    final forecastDays = rawForecastData['forecast']?['forecastday'] as List?;
    if (forecastDays == null) return [];

    final target = forecastDays.firstWhereOrNull((d) => d['date'] == date);
    if (target == null) return [];

    return (target['hour'] as List).map<Map<String, dynamic>>((hour) {
      return {
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
      };
    }).toList();
  }

  Map<String, dynamic>? getCurrentHourData() {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final forecastDays = rawForecastData['forecast']?['forecastday'] as List?;

    final todayData = forecastDays?.firstWhereOrNull((d) => d['date'] == today);
    final hourList = todayData?['hour'] as List?;

    return hourList?.firstWhereOrNull(
      (hour) => DateTime.parse(hour['time']).toLocal().hour == now.hour,
    );
  }

  void selectDay(int index) => selectedForecastIndex.value = index;
  void updateCityIndex(int index) => currentOtherCityIndex.value = index;
  void _updateDate() =>
      currentDate.value = DateFormat('EEEE dd MMMM').format(DateTime.now());

  static void cacheCityData(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }
}
