import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../home/controller/home_controller.dart';

class ForecastController extends GetxController {
  var forecastData = <Map<String, dynamic>>[].obs;
  var selectedDayIndex = 0.obs;
  var mainCityName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadForecastData();
  }

  void loadForecastData() {
    final homeController = Get.find<HomeController>();
    mainCityName.value = homeController.mainCityName;

    // Generate 7-day forecast
    final now = DateTime.now();
    forecastData.value = List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      final temp = 20 + (index * 2) + (index % 2 == 0 ? 5 : -2);
      final minTemp = temp - 8;
      return {
        'day': index == 0 ? 'Today' : DateFormat('EEEE').format(date),
        'date': DateFormat('dd MMMM').format(date),
        'fullDate': date,
        'temp': temp,
        'minTemp': minTemp,
        'condition':
            index % 3 == 0
                ? 'sunny'
                : index % 3 == 1
                ? 'cloudy'
                : 'rainy',
        'humidity': 65 + (index * 5),
        'windSpeed': 10.0 + (index * 2.5),
        'precipitation': index % 2 == 0 ? 0.0 : 2.5 + (index * 0.5),
      };
    });
  }

  void selectDay(int index) {
    selectedDayIndex.value = index;
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

  Map<String, dynamic> get selectedDayData =>
      forecastData[selectedDayIndex.value];
}
