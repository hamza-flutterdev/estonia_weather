import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/weather_info_card.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../cities/cities_view/cities_view.dart';
import '../../../core/common_widgets/weather_icon.dart';
import '../controller/hourly_forecast_controller.dart';

class HourlyForecastView extends StatelessWidget {
  const HourlyForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = Get.arguments;
    final HourlyForecastController controller = Get.find();
    final ConditionController conditionController = Get.find();

    controller.setSelectedDate(selectedDate);

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isTall = constraints.maxHeight > 850;
          final bool isMob = constraints.maxHeight > 400;
          final double imageHeight = constraints.maxHeight * 0.4;
          final double cardTop = constraints.maxHeight * 0.11;
          final double cardHeight =
              isTall
                  ? constraints.maxHeight * 0.41
                  : isMob
                  ? constraints.maxHeight * 0.49
                  : constraints.maxHeight * 0.53;

          return SizedBox(
            height: constraints.maxHeight,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.asset(
                    Assets.images.hourlyForecastBgContainer.path,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: cardTop,
                  left: mobileWidth(context) * 0.05,
                  right: mobileWidth(context) * 0.05,
                  child: Obx(() {
                    final selectedDayData = controller.selectedDayData;
                    if (selectedDayData == null) {
                      return const SizedBox();
                    }
                    return SizedBox(
                      height: cardHeight,
                      child: WeatherInfoCard(
                        weatherData: conditionController.mainCityWeather.value,
                        forecastData: selectedDayData, // Pass the forecast data
                        date: selectedDate,
                        temperature: selectedDayData.maxTemp.round().toString(),
                        condition: selectedDayData.condition,
                        minTemp: selectedDayData.minTemp.round().toString(),
                        iconUrl: selectedDayData.iconUrl,
                      ),
                    );
                  }),
                ),
                Positioned(
                  top: cardHeight + kBodyHp,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: kElementGap),
                        Expanded(
                          child: Obx(
                            () => ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kBodyHp,
                              ),
                              itemCount: controller.hourlyData.length,
                              itemBuilder: (context, index) {
                                final hourData = controller.hourlyData[index];
                                final time = controller.getFormattedTime(
                                  hourData['time'],
                                );
                                final isCurrentHour =
                                    controller.getCurrentHourData() == hourData;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: kElementInnerGap,
                                  ),
                                  child: Container(
                                    decoration: roundedDecorationWithShadow
                                        .copyWith(
                                          color:
                                              isCurrentHour
                                                  ? primaryColor.withValues(
                                                    alpha: 0.1,
                                                  )
                                                  : secondaryColor,
                                          border:
                                              isCurrentHour
                                                  ? Border.all(
                                                    color: primaryColor,
                                                    width: 2,
                                                  )
                                                  : null,
                                        ),
                                    padding: kContentPaddingSmall,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          time,
                                          style: bodyMediumStyle.copyWith(
                                            color: primaryColor,
                                            fontWeight:
                                                isCurrentHour
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                        WeatherIcon(
                                          iconUrl: hourData['iconUrl'],
                                          size: primaryIcon(context),
                                          weatherData: hourData['condition'],
                                        ),
                                        Text(
                                          '${hourData['temp_c'].round()}°',
                                          style: headlineSmallStyle.copyWith(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
