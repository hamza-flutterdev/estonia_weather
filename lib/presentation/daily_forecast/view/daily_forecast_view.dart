import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:estonia_weather/presentation/reusable/controllers/condition_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/weather_info_card.dart';
import '../../../core/constants/constant.dart';
import '../../cities/cities_view/cities_view.dart';
import '../controller/daily_forecast_controller.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = Get.arguments;
    final ForecastController controller = Get.find<ForecastController>();
    final ConditionController conditionController =
        Get.find<ConditionController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        useBackButton: false,
        actions: [
          IconActionButton(
            onTap: () => Get.to(CitiesScreen()),
            icon: Icons.add,
            color: primaryColor,
            size: secondaryIcon(context),
          ),
        ],
        subtitle: '',
      ),
      body: SizedBox(
        height: mobileHeight(context),
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: mobileHeight(context) * 0.4,
              width: double.infinity,
              child: Image.asset(
                'assets/images/daily_img/forecast_bg_container.png',
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: mobileHeight(context) * 0.11,
              left: mobileWidth(context) * 0.05,
              right: mobileWidth(context) * 0.05,
              child: WeatherInfoCard(
                weatherData: conditionController.mainCityWeather.value,
                date: selectedDate,
                temperature: conditionController.temperature,
                condition: conditionController.condition,
                minTemp: controller.selectedDayData.minTemp.round().toString(),
                iconUrl: conditionController.weatherIconUrl,
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.52,
              left: 0,
              right: 0,
              bottom: 0,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final forecast = controller.forecastData[index];
                  return Card(
                    color: secondaryColor,
                    child: ListTile(
                      leading: Text(
                        conditionController.getDayName(forecast.date),
                        style: bodyLargeStyle.copyWith(color: primaryColor),
                      ),
                      title: Text('data'),
                      trailing: Text('data'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
