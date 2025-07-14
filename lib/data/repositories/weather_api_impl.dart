import '../../domain/repositories/weather_repo.dart';
import '../data_source/online_data_sr.dart';
import '../model/weather_model.dart';
import '../model/forecast_model.dart';

class WeatherApiImpl implements WeatherRepo {
  final OnlineDataSource onlineDataSource;

  WeatherApiImpl(this.onlineDataSource);

  @override
  Future<(WeatherModel, List<ForecastModel>)> getWeatherAndForecast(
    double lat,
    double lon,
  ) async {
    try {
      return await onlineDataSource.getWeatherAndForecast(lat: lat, lon: lon);
    } catch (e) {
      throw Exception('Failed to get weather and forecast: $e');
    }
  }

  @override
  Future<String> getCity(double lat, double lon) async {
    return await onlineDataSource.getCity(lat, lon);
  }
}
