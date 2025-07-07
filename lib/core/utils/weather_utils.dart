class WeatherUtils {
  static const String _homeIconPath = 'assets/images/home_img/';

  static const Map<String, String> _homeIcons = {
    'precipitation': '${_homeIconPath}umbrella.png',
    'humidity': '${_homeIconPath}droplet.png',
    'wind': '${_homeIconPath}windy.png',
  };

  static String getWeatherIcon(String condition) {
    return getDefaultIcon();
  }

  static String getDefaultIcon() {
    return 'https://cdn.weatherapi.com/weather/64x64/day/116.png';
  }

  static String getHomeIcon(String type) {
    return _homeIcons[type.toLowerCase()] ?? '';
  }
}
