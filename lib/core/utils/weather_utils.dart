import '../../gen/assets.gen.dart';

class WeatherUtils {
  static const String _defaultIconUrl =
      'https://cdn.weatherapi.com/weather/64x64/day/116.png';

  static final Map<String, String> _homeIcons = {
    'precipitation': Assets.images.precipitationUmbrella.path,
    'humidity': Assets.images.humidityDroplet.path,
    'wind': Assets.images.windy.path,
  };

  static String getWeatherIcon(String condition) {
    return getDefaultIcon();
  }

  static String getDefaultIcon() => _defaultIconUrl;

  static String getHomeIcon(String type) {
    return _homeIcons[type.toLowerCase()] ?? '';
  }
}
