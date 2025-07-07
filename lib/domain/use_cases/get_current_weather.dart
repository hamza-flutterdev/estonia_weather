import '../../data/model/weather_model.dart';
import '../../data/model/forecast_model.dart';
import '../repositories/weather_repo.dart';

class GetWeatherAndForecast {
  final WeatherRepo weatherRepo;

  GetWeatherAndForecast(this.weatherRepo);

  Future<(WeatherModel, List<ForecastModel>)> call(String cityName) {
    return weatherRepo.getWeatherAndForecast(cityName);
  }
}
