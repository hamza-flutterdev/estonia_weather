import 'package:estonia_weather/core/animation/weather_animation.dart';
import 'package:flutter/material.dart';
import 'weather_condition.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final String? imagePath;
  final String? condition;
  final int? weatherCode;
  final double? width;
  final double? height;

  const AnimatedWeatherIcon({
    super.key,
    this.imagePath,
    this.condition,
    this.weatherCode,
    this.width,
    this.height,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with TickerProviderStateMixin {
  late WeatherAnimationController _weatherAnimationController;

  @override
  void initState() {
    super.initState();
    _weatherAnimationController = WeatherAnimationController();
    _weatherAnimationController.initialize(
      vsync: this,
      condition: _getWeatherCondition(),
    );
  }

  WeatherCondition _getWeatherCondition() {
    if (widget.weatherCode != null) {
      final code = widget.weatherCode!;
      return code.toWeatherCondition;
    }
    if (widget.condition != null) {
      final cond = widget.condition!;
      return cond.toWeatherCondition;
    }
    return WeatherCondition.clear;
  }

  @override
  void didUpdateWidget(AnimatedWeatherIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.condition != widget.condition ||
        oldWidget.weatherCode != widget.weatherCode) {
      _weatherAnimationController.updateCondition(_getWeatherCondition());
    }
  }

  @override
  void dispose() {
    _weatherAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _weatherAnimationController.applyAnimation(
      Image.asset(
        widget.imagePath ?? '',
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
