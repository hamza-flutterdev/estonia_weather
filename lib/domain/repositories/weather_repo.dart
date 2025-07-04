import '../../data/model/weather_model.dart';

abstract class WeatherRepo {
  Future<WeatherModel> getCurrentWeather(String cityName);
}
