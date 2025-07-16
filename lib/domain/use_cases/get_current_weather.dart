import 'dart:async';

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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Location services are disabled. Please enable location services.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied. Please enable location access in settings.',
      );
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 10),
        ),
      );

      await savePosition(position);
      return weatherRepo.getCity(position.latitude, position.longitude);
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        throw Exception(
          'Location services are disabled. Please enable location services.',
        );
      } else if (e is PermissionDeniedException) {
        throw Exception('Location permission denied');
      } else if (e is TimeoutException) {
        throw Exception('Location request timed out. Please try again.');
      } else {
        throw Exception('Failed to get current location: ${e.toString()}');
      }
    }
  }

  Future<void> savePosition(Position position) async {
    await storage.setString('latitude', position.latitude.toString());
    await storage.setString('longitude', position.longitude.toString());
  }
}
