import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/presentation/home/view/today_forecast_card.dart';
import 'package:estonia_weather/presentation/home/view/weather_detail_item.dart';
import 'package:estonia_weather/presentation/home/view/weather_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/weather_info_card.dart';
import '../../../core/constants/constant.dart';
import '../../cities/cities_view/cities_view.dart';
import '../../reusable/controllers/condition_controller.dart';
import '../controller/home_controller.dart';
import 'other_city_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final ConditionController conditionController = Get.find();

    return Scaffold(
      backgroundColor: bgColor,
      drawer: const Drawer(),
      appBar: CustomAppBar(
        title: Obx(() => Text(homeController.mainCityName)),
        subtitle: homeController.currentDate.value,
        useBackButton: false,
        actions: [
          IconActionButton(
            onTap: () => Get.to(CitiesScreen()),
            icon: Icons.add,
            color: primaryColor,
            size: secondaryIcon(context),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            Positioned(
              top: kBodyHp,
              left: mobileWidth(context) * 0.15,
              right: mobileWidth(context) * 0.15,
              child: WeatherInfoCard(
                temperature: conditionController.temperature,
                condition: conditionController.condition,
                iconUrl: conditionController.weatherIconUrl,
                useGradient: true,
                showWeatherDetails: false,
                showIcon: false,
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.1,
              left: mobileWidth(context) * 0.05,
              child: WeatherIcon(
                weatherData: conditionController.mainCityWeather.value,
                iconUrl: conditionController.weatherIconUrl,
                size: largeIcon(context),
              ),
            ),
            const WeatherDetailsCard(),
            const TodayForecastSection(),
            const OtherCitiesSection(),
          ],
        ),
      ),
    );
  }
}
