import '../../data/model/weather_model.dart';
import '../../data/model/forecast_model.dart';

abstract class WeatherRepo {
  Future<(WeatherModel, List<ForecastModel>)> getWeatherAndForecast(
    double lat,
    double lon,
  );
}
