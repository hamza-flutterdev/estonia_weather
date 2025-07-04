import 'package:get/get.dart';
import '../../../data/model/weather_model.dart';
import '../../../core/utils/weather_utils.dart';

class ConditionController extends GetxController {
  final mainCityWeather = Rx<WeatherModel?>(null);
  final selectedCitiesWeather = <WeatherModel>[].obs;
  final mainCityIndex = 0.obs;

  String get temperature {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.temperature.round()}°'
        : '--°';
  }

  String get condition {
    return mainCityWeather.value?.condition ?? 'Loading...';
  }

  String get precipitation {
    return mainCityWeather.value != null
        ? WeatherUtils.convertPrecipitationToPercentage(
          mainCityWeather.value!.precipitation,
        )
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

  String get weatherIcon {
    return mainCityWeather.value != null
        ? WeatherUtils.getWeatherIcon(mainCityWeather.value!.condition)
        : WeatherUtils.getDefaultIcon();
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

  void updateWeatherData(List<WeatherModel> weatherList, int mainIndex) {
    selectedCitiesWeather.value = weatherList;
    mainCityIndex.value = mainIndex;

    if (weatherList.isNotEmpty && mainIndex < weatherList.length) {
      mainCityWeather.value = weatherList[mainIndex];
    }
  }

  void clearWeatherData() {
    mainCityWeather.value = null;
    selectedCitiesWeather.clear();
  }
}
