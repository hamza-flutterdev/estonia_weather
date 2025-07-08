import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';
import '../../../data/model/forecast_model.dart';

class HourlyForecastController extends GetxController {
  var forecastData = <ForecastModel>[].obs;
  var selectedDate = DateTime.now().obs;
  var mainCityName = ''.obs;
  var hourlyData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadForecastData();
    loadHourlyData();
  }

  void loadForecastData() {
    final homeController = Get.find<HomeController>();
    mainCityName.value = homeController.mainCityName;
    forecastData.value = homeController.forecastData;
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    loadHourlyData();
  }

  void loadHourlyData() {
    final homeController = Get.find<HomeController>();
    final selectedForecast = forecastData.firstWhereOrNull(
      (forecast) =>
          isSameDate(DateTime.parse(forecast.date), selectedDate.value),
    );

    if (selectedForecast != null) {
      final hourlyForecast = homeController.getHourlyDataForDate(
        selectedForecast.date,
      );
      hourlyData.value = hourlyForecast;
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String getFormattedTime(String timeString) {
    final time = DateTime.parse(timeString);
    final hour = time.hour;
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    if (hour < 12) return '$hour AM';
    return '${hour - 12} PM';
  }

  String getFormattedDate() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final month = months[selectedDate.value.month - 1];
    final day = selectedDate.value.day;
    return '$month $day';
  }

  ForecastModel? get selectedDayData {
    return forecastData.firstWhereOrNull(
      (forecast) =>
          isSameDate(DateTime.parse(forecast.date), selectedDate.value),
    );
  }

  Map<String, dynamic>? getCurrentHourData() {
    final now = DateTime.now();
    if (isSameDate(selectedDate.value, now)) {
      return hourlyData.firstWhereOrNull(
        (hour) => DateTime.parse(hour['time']).hour == now.hour,
      );
    }
    return null;
  }

  List<Map<String, dynamic>> getUpcomingHours() {
    final now = DateTime.now();
    if (isSameDate(selectedDate.value, now)) {
      return hourlyData
          .where((hour) => DateTime.parse(hour['time']).isAfter(now))
          .toList();
    }
    return hourlyData;
  }
}
