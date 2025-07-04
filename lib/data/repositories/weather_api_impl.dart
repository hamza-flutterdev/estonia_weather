import '../../domain/repositories/weather_repo.dart';
import '../data_source/online_data_sr.dart';
import '../model/weather_model.dart';

class WeatherApiImpl implements WeatherRepo {
  final OnlineDataSource onlineDataSource;

  WeatherApiImpl(this.onlineDataSource);

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
      return await onlineDataSource.getWeatherByCity(cityName);
    } catch (e) {
      throw Exception('Failed to get weather: $e');
    }
  }
}
