import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';

class ConditionController extends GetxController {
  final mainCityWeather = Rx<WeatherModel?>(null);
  final selectedCitiesWeather = <WeatherModel>[].obs;
  final weeklyForecast = <Map<String, dynamic>>[].obs;
  final mainCityIndex = 0.obs;
  final mainCityName = ''.obs;

  // Current weather getters (unchanged)
  String get temperature {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.temperature.round()}°'
        : '--°';
  }

  String get condition {
    return mainCityWeather.value?.condition ?? 'Loading...';
  }

  String get chanceOfRain {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.chanceOfRain}%'
        : '--%';
  }

  String get humidity {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.humidity}%'
        : '--%';
  }

  String get windSpeed {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.windSpeed.toStringAsFixed(1)}km/h'
        : '--km/h';
  }

  String get weatherIconUrl {
    return mainCityWeather.value != null
        ? mainCityWeather.value!.iconUrl
        : 'https://cdn.weatherapi.com/weather/64x64/day/116.png';
  }

  // New methods to get weather details for forecast data
  String getChanceOfRainForForecast(ForecastModel? forecast) {
    if (forecast != null) {
      return '${forecast.chanceOfRain}%';
    }
    return chanceOfRain; // Fallback to current weather
  }

  String getHumidityForForecast(ForecastModel? forecast) {
    if (forecast != null) {
      return '${forecast.humidity}%';
    }
    return humidity; // Fallback to current weather
  }

  String getWindSpeedForForecast(ForecastModel? forecast) {
    if (forecast != null) {
      return '${forecast.windSpeed.toStringAsFixed(1)}km/h';
    }
    return windSpeed; // Fallback to current weather
  }

  // Raw values for when you need integers/doubles instead of formatted strings
  int get rawChanceOfRain {
    return mainCityWeather.value?.chanceOfRain ?? 0;
  }

  int get rawHumidity {
    return mainCityWeather.value?.humidity ?? 0;
  }

  double get rawWindSpeed {
    return mainCityWeather.value?.windSpeed ?? 0.0;
  }

  int getRawChanceOfRainForForecast(ForecastModel? forecast) {
    return forecast?.chanceOfRain ?? rawChanceOfRain;
  }

  int getRawHumidityForForecast(ForecastModel? forecast) {
    return forecast?.humidity ?? rawHumidity;
  }

  double getRawWindSpeedForForecast(ForecastModel? forecast) {
    return forecast?.windSpeed ?? rawWindSpeed;
  }

  List<WeatherModel> get otherCitiesWeather {
    if (selectedCitiesWeather.length <= 1) return [];
    List<WeatherModel> otherCities = [];
    for (int i = 0; i < selectedCitiesWeather.length; i++) {
      if (i != mainCityIndex.value) {
        otherCities.add(selectedCitiesWeather[i]);
      }
    }
    return otherCities;
  }

  void updateWeatherData(
    List<WeatherModel> weatherList,
    int mainIndex,
    String cityName,
  ) {
    selectedCitiesWeather.value = weatherList;
    mainCityIndex.value = mainIndex;
    mainCityName.value = cityName;
    if (weatherList.isNotEmpty && mainIndex < weatherList.length) {
      mainCityWeather.value = weatherList[mainIndex];
    }
  }

  void updateWeeklyForecast(List<ForecastModel> forecastList) {
    weeklyForecast.value =
        forecastList.map((forecast) {
          return {
            'day': getDayName(forecast.date),
            'date': DateTime.parse(forecast.date),
            'dateString': forecast.date,
            'temp': forecast.maxTemp,
            'minTemp': forecast.minTemp,
            'iconUrl': forecast.iconUrl,
            'condition': forecast.condition,
            'humidity': forecast.humidity,
            'windSpeed': forecast.windSpeed,
            'chanceOfRain': forecast.chanceOfRain,
          };
        }).toList();
  }

  String getDayName(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = targetDate.difference(today).inDays;
    if (difference == 0) {
      return 'Today';
    } else {
      return DateFormat('EEE').format(date);
    }
  }

  String getFormattedDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMMM').format(date);
  }

  String getShortDayName(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = targetDate.difference(today).inDays;
    if (difference == 0) {
      return 'Today';
    } else {
      return DateFormat('EEE').format(date);
    }
  }

  bool get hasForecastData => weeklyForecast.isNotEmpty;

  Map<String, dynamic>? getForecastForDay(int index) {
    if (index >= 0 && index < weeklyForecast.length) {
      return weeklyForecast[index];
    }
    return null;
  }

  void clearWeatherData() {
    mainCityWeather.value = null;
    selectedCitiesWeather.clear();
    weeklyForecast.clear();
    mainCityName.value = '';
  }
}
