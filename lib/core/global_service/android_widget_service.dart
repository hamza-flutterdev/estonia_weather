import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:estonia_weather/core/global_service/controllers/condition_controller.dart';
import 'package:estonia_weather/presentation/home/controller/home_controller.dart';
import 'package:estonia_weather/core/utils/weather_utils.dart';

class WidgetUpdateManager {
  static Timer? _timer;

  static void startPeriodicUpdate() async {
    _timer?.cancel();

    final isActive = await WidgetUpdaterService.isWidgetActive();
    if (!isActive) {
      debugPrint("📵 Widget not active. Skipping periodic updates.");
      return;
    }

    updateWeatherWidget();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      updateWeatherWidget();
      debugPrint('Refreshing widget...');
    });
  }

  static void updateWeatherWidget() {
    try {
      final HomeController homeController = Get.find();
      final ConditionController conditionController = Get.find();

      final mainCityName = homeController.mainCityName;

      final weatherData = {
        'cityName': mainCityName,
        'temperature': conditionController.temperature.toString(),
        'condition': conditionController.condition,
        'iconUrl': WeatherUtils.getDefaultIcon(),
        'minTemp': conditionController.minTemp.toString(),
        'maxTemp': conditionController.maxTemp.toString(),
      };

      WidgetUpdaterService.updateWidget(weatherData);
    } catch (e) {
      debugPrint("Error updating widget with weather data: $e");
    }
  }
}

class WidgetUpdaterService {
  static const _platform = MethodChannel(
    'com.unisoftaps.estoniaweatherforecast/widget',
  );

  static Future<void> updateWidget(Map<String, String> weatherData) async {
    try {
      await _platform.invokeMethod('updateWidget', weatherData);
    } on PlatformException catch (e) {
      debugPrint("Failed to update widget: ${e.message}");
    }
  }

  static Future<bool> isWidgetActive() async {
    try {
      final bool? result = await _platform.invokeMethod('isWidgetActive');
      return result ?? false;
    } catch (e) {
      debugPrint('Error checking widget activity: $e');
      return false;
    }
  }
}
