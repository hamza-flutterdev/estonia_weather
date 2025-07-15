import 'package:geolocator/geolocator.dart';

import '../../core/local_storage/local_storage.dart';
import '../../data/model/weather_model.dart';
import '../../data/model/forecast_model.dart';
import '../repositories/weather_repo.dart';

class GetWeatherAndForecast {
  final WeatherRepo weatherRepo;
  final storage = LocalStorage();

  GetWeatherAndForecast(this.weatherRepo);

  Future<(WeatherModel, List<ForecastModel>)> call({
    required double lat,
    required double lon,
  }) {
    return weatherRepo.getWeatherAndForecast(lat, lon);
  }

  Future<String> getCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );

    await savePosition(position);

    return weatherRepo.getCity(position.latitude, position.longitude);
  }

  Future<void> savePosition(Position position) async {
    await storage.setString('latitude', position.latitude.toString());
    await storage.setString('longitude', position.longitude.toString());
  }
}
