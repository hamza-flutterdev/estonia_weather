import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../../gen/assets.gen.dart';
import '../../cities/controller/cities_controller.dart';

class HomeController extends GetxController {
  final GetWeatherAndForecast getCurrentWeather;
  final ConditionController conditionController = Get.find();
  final LocalStorage localStorage = LocalStorage();

  HomeController(this.getCurrentWeather);

  final currentLocation = ''.obs;
  final currentLocationCity = Rx<EstonianCity?>(null);
  final selectedCities = <EstonianCity>[].obs;
  final allCities = <EstonianCity>[].obs;
  final forecastData = <ForecastModel>[].obs;
  final rawForecastData = <String, dynamic>{}.obs;
  final currentDate = ''.obs;
  final mainCityIndex = 0.obs;
  final selectedForecastIndex = 0.obs;
  final currentOtherCityIndex = 0.obs;
  final isLoading = false.obs;
  final isFirstLaunch = true.obs;

  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};

  @override
  void onInit() {
    super.onInit();
    _updateCurrentDate();
    _loadAllCities();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final savedCitiesJson = await localStorage.getString('selected_cities');
      final hasCurrentLocation =
          await localStorage.getBool('has_current_location') ?? false;

      if (savedCitiesJson == null || !hasCurrentLocation) {
        isFirstLaunch.value = true;
        await _setupFirstLaunch();
      } else {
        isFirstLaunch.value = false;
        await _fetchCurrentLocation(); // Still fetch current location for comparison
        await _loadSelectedCitiesFromStorage();
      }
    } catch (e) {
      debugPrint('Error checking first launch: $e');
      isFirstLaunch.value = true;
      await _setupFirstLaunch();
    }
  }

  Future<void> _setupFirstLaunch() async {
    try {
      isLoading.value = true;

      // Fetch current location first
      await _fetchCurrentLocation();

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

      // Load weather data
      await loadSelectedCitiesWeather();

      // Mark first launch as complete only after everything is loaded
      isFirstLaunch.value = false;
    } catch (e) {
      debugPrint('Failed to setup first launch: $e');
      // Fallback setup
      selectedCities.value = allCities.take(3).toList();
      mainCityIndex.value = 0;
      await _saveSelectedCitiesToStorage();
      await loadSelectedCitiesWeather();
      isFirstLaunch.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final city = await getCurrentWeather.getCity();
      currentLocation.value = city;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 30),
        ),
      );

      final foundCity = allCities.firstWhere(
        (c) => c.city.toLowerCase() == city.toLowerCase(),
        orElse:
            () => EstonianCity(
              city: city,
              cityAscii: city,
              lat: position.latitude,
              lng: position.longitude,
              country: 'Current Location',
              iso2: 'CL',
              iso3: 'CUR',
              adminName: 'Current Location',
              capital: 'primary',
              population: 0,
              id: 999999,
            ),
      );

      currentLocationCity.value = foundCity;
    } catch (e) {
      debugPrint('Failed to fetch current location: $e');
      currentLocation.value = 'Unknown';
      currentLocationCity.value = null;
    }
  }

  Future<void> addCurrentLocationToSelectedAsMain() async {
    if (currentLocationCity.value != null) {
      if (!isCitySelected(currentLocationCity.value!)) {
        selectedCities.insert(0, currentLocationCity.value!);

        if (selectedCities.length > CitiesController.maxCities) {
          selectedCities.removeLast();
        }
      } else {
        selectedCities.removeWhere(
          (city) => city.city == currentLocationCity.value!.city,
        );
        selectedCities.insert(0, currentLocationCity.value!);
      }

      mainCityIndex.value = 0;

      await _saveSelectedCitiesToStorage();
      await loadSelectedCitiesWeather();
    }
  }

  Future<void> addCityToSelected(EstonianCity city) async {
    if (!selectedCities.any((c) => c.city == city.city)) {
      selectedCities.add(city);
      await _saveSelectedCitiesToStorage();
      await loadSelectedCitiesWeather();
    }
  }

  Future<void> removeCityFromSelected(EstonianCity city) async {
    if (currentLocationCity.value != null &&
        city.city == currentLocationCity.value!.city) {
      return;
    }

    if (selectedCities.length > 2) {
      selectedCities.removeWhere((c) => c.city == city.city);

      if (mainCityIndex.value >= selectedCities.length) {
        mainCityIndex.value = selectedCities.length - 1;
      }

      unawaited(_saveSelectedCitiesToStorage());
      unawaited(loadSelectedCitiesWeather());
    }
  }

  bool isCitySelected(EstonianCity city) =>
      selectedCities.any((c) => c.city == city.city);

  bool isCurrentLocationCity(EstonianCity city) =>
      currentLocationCity.value != null &&
      city.city == currentLocationCity.value!.city;

  Future<void> addCurrentLocationToSelected() async {
    if (currentLocationCity.value != null &&
        !isCitySelected(currentLocationCity.value!)) {
      selectedCities.insert(0, currentLocationCity.value!);
      mainCityIndex.value = mainCityIndex.value + 1;
      await _saveSelectedCitiesToStorage();
      await loadSelectedCitiesWeather();
    }
  }

  Future<void> swapCityWithMainByWeatherModel(WeatherModel weatherModel) async {
    try {
      isLoading.value = true;
      int newMainCityIndex = selectedCities.indexWhere(
        (c) => c.cityAscii.toLowerCase() == weatherModel.cityName.toLowerCase(),
      );

      if (newMainCityIndex == -1) {
        final citiesWeather = conditionController.selectedCitiesWeather;
        newMainCityIndex = citiesWeather.indexWhere(
          (w) =>
              w.cityName.toLowerCase() == weatherModel.cityName.toLowerCase(),
        );
      }

      if (newMainCityIndex >= 0 && newMainCityIndex != mainCityIndex.value) {
        mainCityIndex.value = newMainCityIndex;
        await _saveSelectedCitiesToStorage();
        await loadSelectedCitiesWeather();
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
      selectedCities.isNotEmpty && mainCityIndex.value < selectedCities.length
          ? selectedCities[mainCityIndex.value].city
          : 'Loading...';

  void _updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat('EEEE dd MMMM').format(now);
  }

  Future<void> _loadAllCities() async {
    try {
      isLoading.value = true;
      final String response = await rootBundle.loadString(
        Assets.database.cities,
      );
      final List<dynamic> data = json.decode(response);
      allCities.value =
          data.map((city) => EstonianCity.fromJson(city)).toList();
    } catch (e) {
      debugPrint("Failed to load cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSelectedCitiesFromStorage() async {
    try {
      debugPrint('Loading weather for ${selectedCities.length} cities');
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
        debugPrint('Main city index: ${mainCityIndex.value}');
        debugPrint('Raw data storage keys: ${_rawDataStorage.keys.toList()}');
      }

      await loadSelectedCitiesWeather();
    } catch (e) {
      debugPrint("Failed to load selected cities from storage: $e");
      selectedCities.value = allCities.take(2).toList();
      await _saveSelectedCitiesToStorage();
      await loadSelectedCitiesWeather();
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

  Future<void> loadSelectedCitiesWeather() async {
    try {
      isLoading.value = true;

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
            forecastData.value = forecast;
            mainCityRawData = _rawDataStorage[city.city];
          }
        } catch (e) {
          debugPrint('Failed to load weather for ${city.city}: $e');
          // Continue with other cities even if one fails
        }
      }

      if (mainCityRawData != null) {
        rawForecastData.value = mainCityRawData;
      }

      // Only update if we have weather data
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
    } finally {
      isLoading.value = false;
    }
  }

  static void storeRawDataForCity(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }
}
