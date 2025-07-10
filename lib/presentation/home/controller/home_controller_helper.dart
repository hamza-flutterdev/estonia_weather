import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../gen/assets.gen.dart';
import 'package:get/get.dart';

class HomeControllerHelpers {
  static void updateCurrentDate(RxString currentDate) {
    final now = DateTime.now();
    currentDate.value = DateFormat('EEEE dd MMMM').format(now);
  }

  static Future<void> loadAllCities(
    RxList<EstonianCity> allCities,
    RxBool isLoading,
  ) async {
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

  static Future<void> loadSelectedCitiesFromStorage(
    RxList<EstonianCity> allCities,
    RxList<EstonianCity> selectedCities,
    LocalStorage localStorage,
    Future<void> Function() saveToStorage,
    Future<void> Function() loadWeather,
  ) async {
    try {
      final savedCitiesJson = await localStorage.getString('selected_cities');
      if (savedCitiesJson != null) {
        final List<dynamic> savedCitiesData = json.decode(savedCitiesJson);
        final savedCities =
            savedCitiesData.map((e) => EstonianCity.fromJson(e)).toList();
        selectedCities.value =
            savedCities.length >= 3 ? savedCities : allCities.take(3).toList();
      } else {
        selectedCities.value = allCities.take(3).toList();
        await saveToStorage();
      }
      await loadWeather();
    } catch (e) {
      debugPrint("Failed to load selected cities from storage: $e");
      selectedCities.value = allCities.take(3).toList();
      await saveToStorage();
      await loadWeather();
    }
  }

  static Future<void> saveSelectedCitiesToStorage(
    RxList<EstonianCity> selectedCities,
    LocalStorage localStorage,
  ) async {
    try {
      final citiesJson = json.encode(
        selectedCities.map((e) => e.toJson()).toList(),
      );
      await localStorage.setString('selected_cities', citiesJson);
    } catch (e) {
      debugPrint("Failed to save selected cities to storage: $e");
    }
  }

  static Future<void> loadSelectedCitiesWeather(
    RxList<EstonianCity> selectedCities,
    GetWeatherAndForecast getWeather,
    RxInt mainCityIndex,
    RxList<ForecastModel> forecastData,
    RxBool isLoading,
    ConditionController conditionController,
    String mainCityName,
  ) async {
    try {
      isLoading.value = true;
      List<WeatherModel> weatherList = [];
      List<ForecastModel> mainCityForecast = [];

      for (int i = 0; i < selectedCities.length; i++) {
        final city = selectedCities[i];
        final (weather, forecast) = await getWeather(
          lat: city.lat,
          lon: city.lng,
        );
        weatherList.add(weather);

        if (i == mainCityIndex.value) {
          mainCityForecast = forecast;
          forecastData.value = forecast;
        }
      }

      conditionController.updateWeatherData(
        weatherList,
        mainCityIndex.value,
        mainCityName,
      );
      if (mainCityForecast.isNotEmpty) {
        conditionController.updateWeeklyForecast(mainCityForecast);
      }
    } catch (e) {
      debugPrint('Failed to load weather data: $e');
      conditionController.clearWeatherData();
    } finally {
      isLoading.value = false;
    }
  }

  static Future<void> swapCityWithMainByWeatherModel(
    WeatherModel weatherModel,
    RxList<EstonianCity> selectedCities,
    RxInt mainCityIndex,
    Future<void> Function() saveToStorage,
    Future<void> Function() loadWeather,
    ConditionController conditionController,
    RxBool isLoading,
  ) async {
    try {
      isLoading.value = true;
      if (weatherModel.cityName == selectedCities[mainCityIndex.value].city) {
        return;
      }

      int indexToSwap = selectedCities.indexWhere(
        (c) => c.cityAscii.toLowerCase() == weatherModel.cityName.toLowerCase(),
      );

      if (indexToSwap == -1) {
        final citiesWeather = conditionController.selectedCitiesWeather;
        indexToSwap = citiesWeather.indexWhere(
          (w) =>
              w.cityName.toLowerCase() == weatherModel.cityName.toLowerCase(),
        );
      }

      if (indexToSwap >= 0) {
        final temp = selectedCities[mainCityIndex.value];
        selectedCities[mainCityIndex.value] = selectedCities[indexToSwap];
        selectedCities[indexToSwap] = temp;
        await saveToStorage();
        await loadWeather();
      }
    } catch (e) {
      debugPrint('Failed to swap cities: $e');
    } finally {
      isLoading.value = false;
    }
  }

  static List<Map<String, dynamic>> getHourlyDataForDate(
    String date,
    Map<String, dynamic> rawForecastData,
  ) {
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
}
