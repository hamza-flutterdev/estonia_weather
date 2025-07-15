import 'package:estonia_weather/core/global_service/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';
import '../../../data/model/forecast_model.dart';

class DailyForecastController extends GetxController with ConnectivityMixin {
  var forecastData = <ForecastModel>[].obs;
  final homeController = Get.find<HomeController>();
  var selectedDayIndex = 0.obs;
  var mainCityName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadForecastData();
  }

  @override
  void onReady() {
    super.onReady();
    _initWithConnectivityCheck(Get.context!);
  }

  Future<void> _initWithConnectivityCheck(BuildContext context) async {
    debugPrint('[CitiesController] Initializing with connectivity check');

    final hasInternet = await connectivityService.checkInternetWithDialog(
      context,
      onRetry: () => _initWithConnectivityCheck(context),
    );

    if (hasInternet) {
      loadForecastData();
    } else {
      debugPrint(
        '[CitiesController] No internet at startup – retry dialog shown',
      );
    }
  }

  void loadForecastData() {
    mainCityName.value = homeController.mainCityName;
    forecastData.value = homeController.forecastData;
  }

  @override
  void onInternetConnected() {
    super.onInternetConnected();
    debugPrint(
      '[CitiesController] Internet connected — waiting for user retry',
    );
  }

  @override
  void onInternetDisconnected() {
    super.onInternetDisconnected();
    debugPrint('[CitiesController] Internet disconnected');
  }

  ForecastModel? get selectedDayData => forecastData[selectedDayIndex.value];
}
