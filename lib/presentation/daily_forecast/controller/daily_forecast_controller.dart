import 'package:estonia_weather/core/global_service/connectivity_service.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../home/controller/home_controller.dart';
import '../../../data/model/forecast_model.dart';

class DailyForecastController extends GetxController with ConnectivityMixin {
  var forecastData = <ForecastModel>[].obs;
  final homeController = Get.find<HomeController>();
  var selectedDayIndex = 0.obs;
  var mainCityName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<InterstitialAdController>().checkAndShowAd();
    Get.find<BannerAdController>().loadBannerAd('ad2');
    loadForecastData();
  }

  @override
  void onReady() {
    super.onReady();
    initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async {
        loadForecastData();
      },
    );
  }

  void loadForecastData() {
    mainCityName.value = homeController.mainCityName;
    forecastData.value = homeController.forecastData;
  }

  ForecastModel? get selectedDayData => forecastData[selectedDayIndex.value];
}
