class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final double precipitation;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    double precipitationAmount = 0.0;
    if (json['rain'] != null && json['rain']['1h'] != null) {
      precipitationAmount += (json['rain']['1h'] as num).toDouble();
    }
    if (json['snow'] != null && json['snow']['1h'] != null) {
      precipitationAmount += (json['snow']['1h'] as num).toDouble();
    }
    double windSpeedKmh = (json['wind']['speed'] as num).toDouble() * 3.6;
    return WeatherModel(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: windSpeedKmh,
      precipitation: precipitationAmount,
    );
  }
}
