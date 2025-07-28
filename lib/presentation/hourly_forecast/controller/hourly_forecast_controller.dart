import 'package:estonia_weather/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/global_service/connectivity_service.dart';
import '../../home/controller/home_controller.dart';
import '../../../data/model/forecast_model.dart';
import '../../../core/global_service/controllers/condition_controller.dart';

class HourlyForecastController extends GetxController with ConnectivityMixin {
  final _homeController = Get.find<HomeController>();
  final _conditionController = Get.find<ConditionController>();
  final scrollController = ScrollController();

  final forecastData = <ForecastModel>[].obs;
  final selectedDate = DateTime.now().obs;
  final mainCityName = ''.obs;
  final hourlyData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadForecastData();
  }

  @override
  void onReady() {
    super.onReady();
    initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async => _loadForecastData(),
    );
  }

  void _loadForecastData() {
    mainCityName.value = _homeController.mainCityName;
    forecastData.value = _homeController.forecastData;
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    _loadHourlyData();
  }

  void _loadHourlyData() {
    final selectedForecast = _getForecastForDate(selectedDate.value);
    if (selectedForecast != null) {
      hourlyData.value = _conditionController.getHourlyDataForDate(
        targetDate: selectedForecast.date,
        rawForecastData: _homeController.rawForecastData,
      );
      _autoScrollToCurrentHour();
    }
  }

  ForecastModel? _getForecastForDate(DateTime date) {
    return forecastData.firstWhereOrNull(
      (f) => isSameDate(DateTime.parse(f.date), date),
    );
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _autoScrollToCurrentHour() {
    if (!isSameDate(selectedDate.value, DateTime.now())) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final context = scrollController.position.context.storageContext;
      final itemWidth = mobileWidth(context) / 5;
      final index = hourlyData.indexWhere((h) => getCurrentHourData() == h);

      if (index != -1) {
        final offset = (index * itemWidth).clamp(
          0.0,
          scrollController.position.maxScrollExtent,
        );
        scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  ForecastModel? get selectedDayData => _getForecastForDate(selectedDate.value);

  Map<String, dynamic>? getCurrentHourData() {
    final now = DateTime.now();
    if (isSameDate(selectedDate.value, now)) {
      return hourlyData.firstWhereOrNull(
        (h) => DateTime.parse(h['time']).hour == now.hour,
      );
    }
    return null;
  }

  List<Map<String, dynamic>> getUpcomingHours() {
    final now = DateTime.now();
    return isSameDate(selectedDate.value, now)
        ? hourlyData
            .where((h) => DateTime.parse(h['time']).isAfter(now))
            .toList()
        : hourlyData;
  }

  String getFormattedTime(String timeStr) {
    final hour = DateTime.parse(timeStr).hour;
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    return hour < 12 ? '$hour AM' : '${hour - 12} PM';
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
