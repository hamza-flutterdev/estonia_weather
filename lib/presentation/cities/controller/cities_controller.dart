import 'package:estonia_weather/core/common/app_exceptions.dart';
import 'package:estonia_weather/core/global_service/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/custom_toast.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/city_config.dart';
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

  var allCities = <EstonianCity>[].obs;
  var allCitiesWeather = <WeatherModel>[].obs;
  var filteredCities = <EstonianCity>[].obs;
  var rotatingCity = Rx<EstonianCity?>(null);

  var isLoading = false.obs;
  var isAdding = false.obs;
  var hasSearchError = false.obs;
  var searchErrorMessage = ''.obs;

  @override
  void onReady() {
    super.onReady();
    initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async {
        loadDataFromHome();
        await loadAllCitiesWeather();
      },
    );
    searchController.addListener(() => searchCities(searchController.text));
  }

  void loadDataFromHome() {
    allCities.value = homeController.allCities;
    filteredCities.value = allCities.toList();
    // _initializeRotatingCity();
  }

  // void _initializeRotatingCity() {
  //   final mainCity =
  //       homeController.mainCityIndex < homeController.selectedCities.length
  //           ? homeController.selectedCities[homeController.mainCityIndex]
  //           : null;
  //
  //   if (mainCity != null && !_isTallinnOrNarva(mainCity)) {
  //     rotatingCity.value = mainCity;
  //   } else {
  //     rotatingCity.value = allCities.firstWhereOrNull(
  //       (city) => !_isTallinnOrNarva(city),
  //     );
  //   }
  // }

  bool _isTallinnOrNarva(EstonianCity city) {
    final name = city.cityAscii.toLowerCase();
    return name == 'tallinn' || name == 'narva';
  }

  Future<void> loadAllCitiesWeather() async {
    isLoading.value = true;
    allCitiesWeather.clear();
    try {
      final weatherFutures =
          allCities.map((city) async {
            try {
              final (weather, _) = await getCurrentWeather(
                lat: city.lat,
                lon: city.lng,
              );
              return weather;
            } catch (_) {
              return WeatherModel.empty(city.cityAscii);
            }
          }).toList();

      final results = await Future.wait(weatherFutures);
      allCitiesWeather.addAll(results);
    } catch (e) {
      debugPrint('$failedLoadingWeather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchCities(String query) {
    final lowerQuery = query.toLowerCase();
    final results =
        query.isEmpty
            ? allCities.toList()
            : allCities.where((city) {
              return city.cityAscii.toLowerCase().contains(lowerQuery) ||
                  city.country.toLowerCase().contains(lowerQuery);
            }).toList();

    hasSearchError.value = results.isEmpty && query.isNotEmpty;
    searchErrorMessage.value =
        hasSearchError.value ? '$noCityFound "$query"' : '';
    filteredCities.value = results;
  }

  Future<void> makeCityMain(EstonianCity city) async {
    isAdding.value = true;
    try {
      await homeController.addCity(city);

      if (!_isTallinnOrNarva(city)) {
        rotatingCity.value = city;
      }

      final index = homeController.selectedCities.indexWhere(
        (c) => CityConfig.cityNamesMatch(
          c.cityAscii.toLowerCase(),
          city.cityAscii.toLowerCase(),
        ),
      );

      debugPrint('Found city index: $index for ${city.cityAscii}');

      if (index >= 0) {
        await homeController.makeCityMainByIndex(index);
      } else {
        debugPrint('######Could not find city index for ${city.cityAscii}');
      }
    } finally {
      isAdding.value = false;
    }
  }

  Future<void> addCurrentLocationToSelected(BuildContext context) async {
    void showToast(String message, bool success) {
      SimpleToast.showCustomToast(
        context: context,
        message: message,
        type: success ? ToastificationType.success : ToastificationType.error,
        primaryColor: success ? primaryColor : kRed,
        icon: success ? Icons.location_on : Icons.error_outline,
      );
    }

    isAdding.value = true;
    try {
      final cityName = await getCurrentWeather.getCity();
      final lat = double.tryParse(
        await homeController.localStorage.getString('latitude') ?? '',
      );
      final lon = double.tryParse(
        await homeController.localStorage.getString('longitude') ?? '',
      );

      await homeController.setLocationCity(
        cityName: cityName,
        lat: lat,
        lon: lon,
      );

      final success = homeController.currentLocationCity != null;
      if (success) {
        await homeController.addLocationAsMain();
        loadDataFromHome();
        if (searchController.text.isNotEmpty) {
          searchCities(searchController.text);
        }
      }

      showToast(success ? successCityChange : failedLocation, success);
    } catch (e) {
      final error = e.toString().toLowerCase();
      final message =
          error.contains('denied') || error.contains('services are disabled')
              ? deniedPermission
              : error.contains('timed out')
              ? timeoutException
              : failedLocation;
      showToast(message, false);
      debugPrint('$failedCityChange: $e');
    } finally {
      isAdding.value = false;
    }
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
