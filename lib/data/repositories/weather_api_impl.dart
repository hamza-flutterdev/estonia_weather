import '../../domain/repositories/weather_repo.dart';
import '../data_source/online_data_sr.dart';
import '../model/weather_model.dart';
import '../model/forecast_model.dart';

class WeatherApiImpl implements WeatherRepo {
  final OnlineDataSource onlineDataSource;

  WeatherApiImpl(this.onlineDataSource);

  @override
  Future<(WeatherModel, List<ForecastModel>)> getWeatherAndForecast(
    String cityName,
  ) async {
    try {
      return await onlineDataSource.getWeatherAndForecast(cityName);
    } catch (e) {
      throw Exception('Failed to get weather and forecast: $e');
    }
  }
}
