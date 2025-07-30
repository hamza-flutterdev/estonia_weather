import 'package:estonia_weather/ads_manager/banner_ads.dart';
import 'package:estonia_weather/core/global_service/connectivity_service.dart';
import 'package:estonia_weather/presentation/hourly_forecast/controller/hourly_forecast_controller.dart';
import 'package:estonia_weather/presentation/splash/controller/splash_controller.dart';
import 'package:get/get.dart';
import 'package:estonia_weather/presentation/cities/controller/cities_controller.dart';
import 'package:estonia_weather/presentation/daily_forecast/controller/daily_forecast_controller.dart';
import 'package:estonia_weather/presentation/home/controller/home_controller.dart';
import '../../ads_manager/appOpen_ads.dart';
import '../../ads_manager/interstitial_ads.dart';
import '../../ads_manager/splash_interstitial.dart';
import '../../data/data_source/online_data_sr.dart';
import '../../data/repositories/weather_api_impl.dart';
import '../../domain/repositories/weather_repo.dart';
import '../../domain/use_cases/get_current_weather.dart';
import '../global_service/global_key.dart';
import '../global_service/controllers/condition_controller.dart';

class DependencyInjection {
  static void init() {
    // Connection
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);
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
    Get.lazyPut<SplashController>(
      () => SplashController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );

    Get.lazyPut<CitiesController>(
      () => CitiesController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );

    Get.lazyPut<DailyForecastController>(
      () => DailyForecastController(),
      fenix: true,
    );
    Get.lazyPut<ConditionController>(() => ConditionController(), fenix: true);
    Get.lazyPut<HourlyForecastController>(
      () => HourlyForecastController(),
      fenix: true,
    );
    // Get.lazyPut<AppOpenAdController>(() => AppOpenAdController());
    // Get.lazyPut<InterstitialAdController>(() => InterstitialAdController());
    // Get.lazyPut<SplashInterstitialAdController>(
    //   () => SplashInterstitialAdController(),
    // );
  }
}
