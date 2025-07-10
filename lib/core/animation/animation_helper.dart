import 'package:flutter/material.dart';
import 'animated_weather_icon.dart';

class WeatherAnimationHelper {
  static Widget getAnimatedWeatherIcon({
    required int weatherCode,
    double? width,
    double? height,
  }) {
    return AnimatedWeatherIcon(
      weatherCode: weatherCode,
      width: width,
      height: height,
    );
  }

  static Widget getAnimatedWeatherIconByType({
    required String weatherType,
    double? width,
    double? height,
  }) {
    return AnimatedWeatherIcon(
      condition: weatherType,
      width: width,
      height: height,
    );
  }
}
