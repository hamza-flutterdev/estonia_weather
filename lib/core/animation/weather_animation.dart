import 'package:flutter/material.dart';
import 'dart:math' as math;

enum WeatherCondition { clear, cloudy, rain, sleet, snow, thunderstorm }

class WeatherAnimationController {
  late AnimationController _animationController;
  late Animation<double> _animation;
  WeatherCondition _currentCondition = WeatherCondition.clear;

  void initialize({
    required TickerProvider vsync,
    required WeatherCondition condition,
  }) {
    _currentCondition = condition;
    _animationController = AnimationController(
      duration: _getDurationForCondition(condition),
      vsync: vsync,
    );
    _animation = _getAnimationForCondition(condition);
    _startAnimation();
  }

  Duration _getDurationForCondition(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return const Duration(seconds: 16);
      case WeatherCondition.thunderstorm:
        return const Duration(milliseconds: 1500);
      default:
        return const Duration(seconds: 5);
    }
  }

  Animation<double> _getAnimationForCondition(WeatherCondition condition) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _startAnimation() {
    switch (_currentCondition) {
      case WeatherCondition.clear:
        _animationController.repeat();
        break;
      default:
        _animationController.repeat(reverse: true);
        break;
    }
  }

  void updateCondition(WeatherCondition newCondition) {
    if (_currentCondition != newCondition) {
      _animationController.stop();
      _currentCondition = newCondition;
      _animationController.duration = _getDurationForCondition(newCondition);
      _animation = _getAnimationForCondition(newCondition);
      _startAnimation();
    }
  }

  Widget applyAnimation(Widget child) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return _getTransformedWidget(child);
      },
    );
  }

  Widget _getTransformedWidget(Widget child) {
    switch (_currentCondition) {
      case WeatherCondition.clear:
        return Transform.rotate(
          angle: _animation.value * 2 * math.pi,
          child: child,
        );
      case WeatherCondition.thunderstorm:
        double opacity = 0.2 + (0.8 * _animation.value);
        return Opacity(opacity: opacity, child: child);
      default:
        return Transform.translate(
          offset: Offset(0, -6 * _animation.value),
          child: child,
        );
    }
  }

  void dispose() {
    _animationController.dispose();
  }

  AnimationController get controller => _animationController;
}

extension WeatherConditionExtension on String {
  WeatherCondition get toWeatherCondition {
    switch (toLowerCase()) {
      case 'clear':
        return WeatherCondition.clear;
      case 'cloudy':
        return WeatherCondition.cloudy;
      case 'rain':
        return WeatherCondition.rain;
      case 'sleet':
        return WeatherCondition.sleet;
      case 'snow':
        return WeatherCondition.snow;
      case 'thunderstorm':
        return WeatherCondition.thunderstorm;
      default:
        return WeatherCondition.clear;
    }
  }
}

extension WeatherCodeExtension on int {
  WeatherCondition get toWeatherCondition {
    if ([1000].contains(this)) return WeatherCondition.clear;
    if ([1009, 1030, 1135, 1147, 1003, 1006].contains(this)) {
      return WeatherCondition.cloudy;
    }
    if ([
      1063,
      1150,
      1180,
      1183,
      1240,
      1243,
      1186,
      1192,
      1195,
      1246,
      1273,
      1276,
    ].contains(this)) {
      return WeatherCondition.rain;
    }
    if ([
      1066,
      1210,
      1213,
      1216,
      1219,
      1222,
      1225,
      1255,
      1258,
      1114,
    ].contains(this)) {
      return WeatherCondition.snow;
    }
    if ([
      1069,
      1072,
      1168,
      1171,
      1198,
      1201,
      1204,
      1207,
      1249,
      1252,
      1237,
    ].contains(this)) {
      return WeatherCondition.sleet;
    }
    if ([1087, 1273, 1276, 1279, 1282].contains(this)) {
      return WeatherCondition.thunderstorm;
    }
    return WeatherCondition.clear;
  }
}

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
      return widget.weatherCode!.toWeatherCondition;
    }
    if (widget.condition != null) {
      return widget.condition!.toWeatherCondition;
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
