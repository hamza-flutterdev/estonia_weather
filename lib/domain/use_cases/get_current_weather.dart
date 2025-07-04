import '../../data/model/weather_model.dart';
import '../repositories/weather_repo.dart';

class GetCurrentWeather {
  final WeatherRepo weatherRepo;

  GetCurrentWeather(this.weatherRepo);

  Future<WeatherModel> call(String cityName) async {
    return await weatherRepo.getCurrentWeather(cityName);
  }
}
