import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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

/*
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
see all your functions name
should be small and contextual
>>>>> make all function short remove
try and catch if there is not necessary look very messy

*/

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

  final needsDataRefresh = false.obs;
  final lastDataFetch = Rx<DateTime?>(null);

  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};

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
    super.onInit();
    requestTrackingPermission();
    // widgetsBinding inside the OnInt()???????? search how to use this
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));

      _updateCurrentDate();
      _initializeSafely();

      if (connectivityService.isConnected) {
        await _refreshDataIfNeeded();
      }
    });
  }

  // >>>>>>>>>>> make this separate
  Future<void> requestTrackingPermission() async {
    if (!Platform.isIOS) {
      return;
    }
    final trackingStatus =
    await AppTrackingTransparency.requestTrackingAuthorization();

    switch (trackingStatus) {
      case TrackingStatus.notDetermined:
        print('User has not yet decided');
        break;
      case TrackingStatus.denied:
        print('User denied tracking');
        break;
      case TrackingStatus.authorized:
        print('User granted tracking permission');
        break;
      case TrackingStatus.restricted:
        print('Tracking restricted');
        break;
      default:
        print('Unknown tracking status');
    }
  }

  final GlobalKey<ScaffoldState> globalKey=GlobalKey<ScaffoldState>();
  var isDrawerOpen=false.obs;

  @override
  void onInternetConnected() {
    super.onInternetConnected();

    _refreshDataIfNeeded();
  }
/*
if you already create internet services class/
directly call don't create function for this.
*/
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
      // if working remove this debug print
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

  Future<void> setCurrentLocationCity({
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
      debugPrint(
        '[HomeController] Current location city set to: ${matchedCity.city}',
      );
    } else {
      final fallbackCity = EstonianCity(
        city: cityName,
        cityAscii: cityName,
        lat: lat ?? 0.0,
        lng: lon ?? 0.0,
        country: 'Current Location',
        iso2: 'CL',
        iso3: 'CUR',
        adminName: 'Current Location',
        capital: 'primary',
        population: 0,
        id: 999999,
      );

      _currentLocationCity.value = fallbackCity;
      currentLocation.value = fallbackCity.city;
      debugPrint(
        '[HomeController] No match found — fallback city set: ${fallbackCity.city}',
      );
    }
  }

  void _syncWithSplashController() {
    final splashController = Get.find<SplashController>();
    _selectedCities.value = splashController.selectedCities.toList();
    _mainCityIndex.value = splashController.mainCityIndex.value;
    _currentLocationCity.value = splashController.currentLocationCity.value;
    _isFirstLaunch.value = splashController.isFirstLaunch.value;
  }

  // see this 2 line function look in 7 line??????????
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

      unawaited(_loadWeatherWithConnectivityCheck());
    }
  }

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

        await _loadWeatherWithConnectivityCheck();
      }
    } catch (e) {
      debugPrint('Failed to change main city: $e');
    } finally {
      isLoading.value = false;
    }
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
