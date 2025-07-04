import 'package:get/get.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../home/controller/home_controller.dart';

class CitiesController extends GetxController {
  final GetCurrentWeather getCurrentWeather;
  CitiesController(this.getCurrentWeather);

  var allCities = <EstonianCity>[].obs;
  var selectedCities = <EstonianCity>[].obs;
  var citiesWeather = <WeatherModel>[].obs;
  var mainCityIndex = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Search functionality
  var searchQuery = ''.obs;
  var filteredCities = <EstonianCity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDataFromHome();
    loadCitiesWeather();
    _initializeFilteredCities();
  }

  void _initializeFilteredCities() {
    filteredCities.value =
        allCities.where((city) => !selectedCities.contains(city)).toList();
  }

  void loadDataFromHome() {
    final homeController = Get.find<HomeController>();
    allCities.value = homeController.allCities;
    selectedCities.value = homeController.selectedCities;
    mainCityIndex.value = homeController.mainCityIndex.value;
  }

  Future<void> loadCitiesWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      citiesWeather.clear();

      for (final city in selectedCities) {
        final weather = await getCurrentWeather.call(city.city);
        citiesWeather.add(weather);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load weather data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void searchCities(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCities.value =
          allCities.where((city) => !selectedCities.contains(city)).toList();
    } else {
      filteredCities.value =
          allCities
              .where(
                (city) =>
                    !selectedCities.contains(city) &&
                    (city.city.toLowerCase().contains(query.toLowerCase()) ||
                        city.country.toLowerCase().contains(
                          query.toLowerCase(),
                        )),
              )
              .toList();
    }
  }

  void toggleCitySelection(EstonianCity city) {
    if (selectedCities.contains(city)) {
      if (selectedCities.length > 1) {
        final removedIndex = selectedCities.indexOf(city);
        selectedCities.remove(city);

        // Adjust main city index if needed
        if (mainCityIndex.value == removedIndex) {
          mainCityIndex.value = 0; // Set first city as main
        } else if (mainCityIndex.value > removedIndex) {
          mainCityIndex.value = mainCityIndex.value - 1;
        }
      }
    } else {
      if (selectedCities.length < 10) {
        selectedCities.add(city);
      }
    }

    // Update filtered cities to remove/add the city from available list
    _updateFilteredCities();
    loadCitiesWeather();
  }

  void removeCityAtIndex(int index) {
    if (index < selectedCities.length && selectedCities.length > 1) {
      final cityToRemove = selectedCities[index];
      selectedCities.removeAt(index);

      // Adjust main city index if needed
      if (mainCityIndex.value == index) {
        mainCityIndex.value = 0; // Set first city as main
      } else if (mainCityIndex.value > index) {
        mainCityIndex.value = mainCityIndex.value - 1;
      }

      // Update filtered cities and reload weather
      _updateFilteredCities();
      loadCitiesWeather();
    }
  }

  void _updateFilteredCities() {
    if (searchQuery.value.isEmpty) {
      filteredCities.value =
          allCities.where((city) => !selectedCities.contains(city)).toList();
    } else {
      searchCities(searchQuery.value);
    }
  }

  void setMainCity(int index) {
    if (index < selectedCities.length) {
      mainCityIndex.value = index;
    }
  }

  Future<void> saveAndGoBack() async {
    final homeController = Get.find<HomeController>();
    homeController.selectedCities.value = selectedCities;
    homeController.mainCityIndex.value = mainCityIndex.value;

    // Save to secure storage
    await homeController.saveSelectedCitiesToStorage();
    await homeController.loadSelectedCitiesWeather();

    Get.back();
  }

  String getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return 'assets/images/weather_conditions_img/sunny.png';
      case 'clouds':
      case 'cloudy':
        return 'assets/images/weather_conditions_img/cloudy.png';
      case 'rain':
      case 'rainy':
        return 'assets/images/weather_conditions_img/rainy.png';
      case 'snow':
        return 'assets/images/weather_conditions_img/snowy.png';
      case 'thunderstorm':
        return 'assets/images/weather_conditions_img/storm.png';
      default:
        return 'assets/images/weather_conditions_img/cloudy.png';
    }
  }
}
