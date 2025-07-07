import 'package:estonia_weather/presentation/reusable/controllers/condition_controller.dart';
import 'package:get/get.dart';
import 'package:estonia_weather/presentation/cities/controller/cities_controller.dart';
import 'package:estonia_weather/presentation/daily_forecast/controller/daily_forecast_controller.dart';
import 'package:estonia_weather/presentation/home/controller/home_controller.dart';
import '../../data/data_source/online_data_sr.dart';
import '../../data/repositories/weather_api_impl.dart';
import '../../domain/repositories/weather_repo.dart';
import '../../domain/use_cases/get_current_weather.dart';
import '../constants/global_key.dart';

class DependencyInjection {
  static void init() {
    // 🗂 Data Source
    Get.lazyPut<OnlineDataSource>(() => OnlineDataSource(apiKey), fenix: true);

    // 🏭 Repository
    Get.lazyPut<WeatherRepo>(
      () => WeatherApiImpl(Get.find<OnlineDataSource>()),
      fenix: true,
    );

    // 🔁 Use Cases
    Get.lazyPut<GetWeatherAndForecast>(
      () => GetWeatherAndForecast(Get.find<WeatherRepo>()),
      fenix: true,
    );

    // 📦 Controllers
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<GetWeatherAndForecast>(),
      ), // Fixed: Only pass one parameter
      fenix: true,
    );

    Get.lazyPut<CitiesController>(
      () => CitiesController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );

    Get.lazyPut<ForecastController>(() => ForecastController(), fenix: true);
    Get.lazyPut<ConditionController>(() => ConditionController(), fenix: true);
  }
}
