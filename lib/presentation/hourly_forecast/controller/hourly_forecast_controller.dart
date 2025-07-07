import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../home/controller/home_controller.dart';

class HourlyForecastController extends GetxController {
  var hourlyData = <Map<String, dynamic>>[].obs;
  var selectedDate = DateTime.now().obs;
  var mainCityName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHourlyData();
  }

  void loadHourlyData() {
    final homeController = Get.find<HomeController>();
    mainCityName.value = homeController.mainCityName;

    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      selectedDate.value = args['date'] as DateTime;
    }

    generateHourlyForecast();
  }

  void generateHourlyForecast() {
    final startTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      0,
    );

    hourlyData.value = List.generate(24, (index) {
      final time = startTime.add(Duration(hours: index));
      final baseTemp = 15 + (index / 24 * 10);
      final temp = baseTemp + (index % 3 == 0 ? 2 : -1);
      final precipitation = index % 4 == 0 ? 1.5 + (index * 0.2) : 0.0;

      return {
        'time': DateFormat('HH:mm').format(time),
        'hour': time.hour,
        'temp': temp.round(),
        'condition':
            index % 4 == 0
                ? 'rainy'
                : index % 4 == 1
                ? 'sunny'
                : index % 4 == 2
                ? 'cloudy'
                : 'partly_cloudy',
        'humidity': 60 + (index * 2),
        'windSpeed': 8.0 + (index * 0.5),
        'precipitation': precipitation,
        'precipitationPercentage': convertPrecipitationToPercentage(
          precipitation,
        ),
        'uvIndex':
            index >= 6 && index <= 18 ? ((index - 6) / 12 * 10).round() : 0,
        'visibility': 10.0 - (index * 0.1),
      };
    });
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
      case 'partly_cloudy':
        return 'assets/images/weather_conditions_img/cloudy.png';
      default:
        return 'assets/images/weather_conditions_img/cloudy.png';
    }
  }

  String convertPrecipitationToPercentage(double precipitation) {
    // Convert mm to percentage (assuming 10mm = 100%)
    double percentage = (precipitation / 10.0) * 100;
    return '${percentage.clamp(0, 100).toStringAsFixed(1)}%';
  }

  String get formattedDate =>
      DateFormat('EEEE, dd MMMM').format(selectedDate.value);
}
