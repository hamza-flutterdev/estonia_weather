// lib/core/utils/weather_utils.dart
class WeatherUtils {
  // Weather icon paths
  static const String _basePath = 'assets/images/weather_conditions_img/';
  static const String _homeIconPath = 'assets/images/home_img/';

  static const Map<String, String> _weatherIcons = {
    'clear': '${_basePath}sunny.png',
    'sunny': '${_basePath}sunny.png',
    'clouds': '${_basePath}cloudy.png',
    'cloudy': '${_basePath}cloudy.png',
    'rain': '${_basePath}rainy.png',
    'rainy': '${_basePath}rainy.png',
    'snow': '${_basePath}snowy.png',
    'thunderstorm': '${_basePath}storm.png',
  };

  static const Map<String, String> _homeIcons = {
    'precipitation': '${_homeIconPath}umbrella.png',
    'humidity': '${_homeIconPath}droplet.png',
    'wind': '${_homeIconPath}windy.png',
  };

  static String getWeatherIcon(String condition) {
    return _weatherIcons[condition.toLowerCase()] ?? getDefaultIcon();
  }

  static String getDefaultIcon() {
    return '${_basePath}cloudy.png';
  }

  static String getHomeIcon(String type) {
    return _homeIcons[type.toLowerCase()] ?? '';
  }

  static String convertPrecipitationToPercentage(double precipitation) {
    if (precipitation == 0) return '0%';
    double percentage = (precipitation / 10.0) * 100;
    return '${percentage.clamp(0, 100).toStringAsFixed(1)}%';
  }
}
