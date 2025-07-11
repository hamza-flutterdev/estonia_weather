import 'package:estonia_weather/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';
import '../../../data/model/forecast_model.dart';

class HourlyForecastController extends GetxController {
  final homeController = Get.find<HomeController>();
  var forecastData = <ForecastModel>[].obs;
  var selectedDate = DateTime.now().obs;
  var mainCityName = ''.obs;
  var hourlyData = <Map<String, dynamic>>[].obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadForecastData();
  }

  void loadForecastData() {
    mainCityName.value = homeController.mainCityName;
    forecastData.value = homeController.forecastData;
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    loadHourlyData();
  }

  void loadHourlyData() {
    try {
      final selectedForecast = forecastData.firstWhereOrNull(
        (forecast) =>
            isSameDate(DateTime.parse(forecast.date), selectedDate.value),
      );
      if (selectedForecast != null) {
        final hourlyForecast = homeController.getHourlyDataForDate(
          selectedForecast.date,
        );
        hourlyData.value = hourlyForecast;
        _autoScrollToCurrentHour();
      }
    } catch (e) {
      debugPrint('Error loading hourly data: $e');
    }
  }

  void _autoScrollToCurrentHour() {
    if (!isSameDate(selectedDate.value, DateTime.now())) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      final context = scrollController.position.context.storageContext;
      final itemWidth = mobileWidth(context) / 5;

      final currentHourIndex = hourlyData.indexWhere(
        (hour) => getCurrentHourData() == hour,
      );

      if (currentHourIndex != -1) {
        final scrollOffset = currentHourIndex * itemWidth;
        final maxScroll = scrollController.position.maxScrollExtent;

        scrollController.animateTo(
          scrollOffset > maxScroll ? maxScroll : scrollOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
