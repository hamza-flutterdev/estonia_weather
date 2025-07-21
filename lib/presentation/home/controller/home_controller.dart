import 'dart:async';
import 'dart:convert';
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
  var isDrawerOpen = false.obs;
  final needsDataRefresh = false.obs;
  final lastDataFetch = Rx<DateTime?>(null);
  final splashController = Get.find<SplashController>();

  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};

  EstonianCity? get currentLocationCity => _currentLocationCity.value;
  List<EstonianCity> get selectedCities => _selectedCities.toList();
  List<EstonianCity> get allCities {
    return splashController.allCities.toList();
  }

  int get mainCityIndex => _mainCityIndex.value;
  bool get isFirstLaunch => _isFirstLaunch.value;

  @override
  void onInit() {
    super.onInit();
    requestTrackingPermission();
  }

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

  Future<void> _refreshIfStale() async {
    final now = DateTime.now();
    final shouldRefresh =
        lastDataFetch.value == null ||
        now.difference(lastDataFetch.value!).inMinutes > 10 ||
        needsDataRefresh.value;

    if (shouldRefresh && connectivityService.isConnected) {
      await loadSelectedWeather();
      needsDataRefresh.value = false;
      lastDataFetch.value = now;
    }
  }

  void _safeInit() {
    _syncSplash();
    ever(splashController.isDataLoaded, (bool isLoaded) {
      if (isLoaded) {
        _syncSplash();
        _initWeather();
      }
    });

    if (splashController.isAppReady) {
      _initWeather();
    }
  }

  Future<void> setLocationCity({
    required String cityName,
    double? lat,
    double? lon,
  }) async {
    final matchedCity = allCities.firstWhereOrNull(
      (city) => city.city.toLowerCase() == cityName.toLowerCase(),
    );

    if (matchedCity != null) {
      _currentLocationCity.value = matchedCity;
      currentLocation.value = matchedCity.city;
    } else {
      final fallbackCity = EstonianCity.fallback(cityName);
      _currentLocationCity.value = fallbackCity;
      currentLocation.value = fallbackCity.city;
    }
  }

  void _syncSplash() {
    _selectedCities.value = splashController.selectedCities.toList();
    _mainCityIndex.value = splashController.mainCityIndex.value;
    _currentLocationCity.value = splashController.currentLocationCity.value;
    _isFirstLaunch.value = splashController.isFirstLaunch.value;
  }

  Future<void> _initWeather() async {
    currentLocation.value = currentLocationCity?.city ?? 'Unknown';
    if (connectivityService.isConnected) {
      await loadSelectedWeather();
    } else {
      debugPrint(noInternet);
    }
  }

  Future<void> fetchLocation() async {
    currentLocation.value = currentLocationCity?.city ?? 'Unknown';
  }

  Future<void> addLocationAsMain() async {
    if (currentLocationCity != null) {
      final updatedCities = List<EstonianCity>.from(_selectedCities);
      if (!isSelected(currentLocationCity!)) {
        updatedCities.insert(0, currentLocationCity!);
        if (updatedCities.length > 5) {
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
      await _storeSelectedCities();
      await _updateSplashController();
      await _loadWeatherSafe();
    }
  }

  Future<void> addCity(EstonianCity city) async {
    if (!isSelected(city)) {
      final updatedCities = List<EstonianCity>.from(_selectedCities);
      updatedCities.add(city);
      _selectedCities.value = updatedCities;
      await _storeSelectedCities();
      await _updateSplashController();
      await _loadWeatherSafe();
    }
  }

  Future<void> removeCity(EstonianCity city) async {
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

      unawaited(_storeSelectedCities());
      unawaited(_updateSplashController());
      unawaited(_loadWeatherSafe());
    }
  }

  Future<void> _loadWeatherSafe() async {
    await ensureInternetConnection(
      action: () async {
        await loadSelectedWeather();
      },
      context: Get.context,
    );
  }

  bool isSelected(EstonianCity city) =>
      _selectedCities.any((c) => c.city == city.city);

  bool isLocationCity(EstonianCity city) =>
      currentLocationCity != null && city.city == currentLocationCity!.city;

  Future<void> addLocationCity() async {
    if (currentLocationCity != null && !isSelected(currentLocationCity!)) {
      final updatedCities = List<EstonianCity>.from(_selectedCities);
      updatedCities.insert(0, currentLocationCity!);
      _selectedCities.value = updatedCities;
      _mainCityIndex.value = _mainCityIndex.value + 1;
      await _storeSelectedCities();
      await _updateSplashController();
      await _loadWeatherSafe();
    }
  }

  Future<void> makeCityMain(WeatherModel weatherModel) async {
    isLoading.value = true;
    int newMainCityIndex = _selectedCities.indexWhere(
      (c) => c.cityAscii.toLowerCase() == weatherModel.cityName.toLowerCase(),
    );

    if (newMainCityIndex == -1) {
      final citiesWeather = conditionController.selectedCitiesWeather;
      newMainCityIndex = citiesWeather.indexWhere(
        (w) => w.cityName.toLowerCase() == weatherModel.cityName.toLowerCase(),
      );
    }

    if (newMainCityIndex >= 0 && newMainCityIndex != _mainCityIndex.value) {
      _mainCityIndex.value = newMainCityIndex;
      await _storeSelectedCities();
      await _updateSplashController();
      await _loadWeatherSafe();
    }
    isLoading.value = false;
  }

  List<Map<String, dynamic>> hourlyForDate(String date) {
    final forecastDays = rawForecastData['forecast']?['forecastday'] as List?;
    if (forecastDays == null) return [];

    final targetDay = forecastDays.firstWhereOrNull(
      (day) => day['date'] == date,
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

  void selectDay(int index) => selectedForecastIndex.value = index;
  void updateCityIndex(int index) => currentOtherCityIndex.value = index;

  String get mainCityName =>
      _selectedCities.isNotEmpty && _mainCityIndex.value < selectedCities.length
          ? selectedCities[_mainCityIndex.value].city
          : 'Loading...';

  void _updateDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat('EEEE dd MMMM').format(now);
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

  Future<void> loadSelectedWeather() async {
    if (!connectivityService.isConnected) return;

    isLoading.value = true;
    final weatherList = <WeatherModel>[];
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
        debugPrint('$failedLoadingWeather ${city.city}: $e');
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
    } else {
      conditionController.clearWeatherData();
    }

    isLoading.value = false;
  }

  Map<String, dynamic>? getCurrentHourData() {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final forecastDays = rawForecastData['forecast']?['forecastday'];

    if (forecastDays == null) return null;

    final todayData = (forecastDays as List).firstWhereOrNull(
      (day) => day['date'] == today,
    );

    if (todayData == null) return null;

    final hourlyList = todayData['hour'] as List?;
    if (hourlyList == null) return null;

    final currentHour = hourlyList.firstWhereOrNull((hour) {
      final hourTime = DateTime.parse(hour['time']).toLocal();
      return hourTime.hour == now.hour;
    });

    return currentHour;
  }

  static void cacheCityData(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }
}
