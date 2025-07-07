class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int chanceOfRain;
  final String iconUrl;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.chanceOfRain,
    required this.iconUrl,
  });

  factory WeatherModel.fromForecastJson(Map<String, dynamic> json) {
    double windSpeedKmh = 0.0;
    if (json['current']?['wind_kph'] != null) {
      windSpeedKmh = (json['current']['wind_kph'] as num).toDouble();
    }

    String iconUrl = '';
    if (json['current']?['condition']?['icon'] != null) {
      iconUrl = 'https:${json['current']['condition']['icon']}';
    }

    int currentChanceOfRain = 0;
    if (json['forecast']?['forecastday']?[0]?['hour'] != null) {
      final currentTime = DateTime.now();
      final currentHour = currentTime.hour;

      final hourlyData = json['forecast']['forecastday'][0]['hour'] as List;
      for (var hour in hourlyData) {
        final hourTime = DateTime.parse(hour['time']);
        if (hourTime.hour == currentHour) {
          currentChanceOfRain = hour['chance_of_rain'] ?? 0;
          break;
        }
      }
    }

    return WeatherModel(
      cityName: json['location']['name'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'],
      humidity: json['current']['humidity'],
      windSpeed: windSpeedKmh,
      chanceOfRain: currentChanceOfRain,
      iconUrl: iconUrl,
    );
  }
}
