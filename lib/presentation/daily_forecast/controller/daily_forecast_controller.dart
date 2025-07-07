import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';
import '../../../data/model/forecast_model.dart';

class ForecastController extends GetxController {
  var forecastData = <ForecastModel>[].obs;
  var selectedDayIndex = 0.obs;
  var mainCityName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadForecastData();
  }

  void loadForecastData() {
    final homeController = Get.find<HomeController>();
    mainCityName.value = homeController.mainCityName;
    forecastData.value = homeController.forecastData;
  }

  void selectDay(int index) {
    selectedDayIndex.value = index;
  }

  ForecastModel get selectedDayData => forecastData[selectedDayIndex.value];
}
