import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/common_widgets/section_header.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isTall = constraints.maxHeight > 850;
          final bool isMob = constraints.maxHeight > 400;

          final double imageHeight = constraints.maxHeight * 0.4;
          final double cardTop = constraints.maxHeight * 0.11;

          final double cardHeight =
              isTall
                  ? constraints.maxHeight * 0.38
                  : isMob
                  ? constraints.maxHeight * 0.46
                  : constraints.maxHeight * 0.52;

          final double listItemHeight =
              isMob ? mobileWidth(context) * 0.22 : mobileWidth(context) * 0.22;

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
                    Assets.images.dailyForecastBgContainer.path,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: cardTop,
                  left: mobileWidth(context) * 0.05,
                  right: mobileWidth(context) * 0.05,
                  child: SizedBox(
                    height: cardHeight,
                    child: WeatherInfoCard(
                      weatherData: conditionController.mainCityWeather.value,
                      date: selectedDate,
                      temperature: conditionController.temperature,
                      condition: conditionController.condition,
                      minTemp:
                          controller.selectedDayData.minTemp.round().toString(),
                      iconUrl: conditionController.weatherIconUrl,
                    ),
                  ),
                ),

                Positioned(
                  top: cardHeight + kBodyHp,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: kBodyHp),
                          child: SectionHeader(
                            actionIcon: Icons.location_on,
                            title: '7 Day Forecasts',
                            actionText: 'Location',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(height: kElementGap),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kBodyHp,
                            ),
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final dayData = conditionController
                                  .getForecastForDay(index);
                              if (dayData == null) return const SizedBox();

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: kElementInnerGap,
                                ),
                                child: Container(
                                  decoration: roundedDecorationWithShadow
                                      .copyWith(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                  height: listItemHeight,
                                  padding: kContentPaddingSmall,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: mobileWidth(context) * 0.15,
                                        child: Text(
                                          dayData['day'],
                                          style: bodyLargeStyle.copyWith(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: mobileWidth(context) * 0.14,
                                      ),
                                      WeatherIcon(
                                        iconUrl: dayData['iconUrl'],
                                        size: primaryIcon(context),
                                        weatherData: dayData['condition'],
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          dayData['condition'],
                                          style: bodyLargeStyle.copyWith(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${dayData['temp'].round()}° / ${dayData['minTemp'].round()}°',
                                        style: bodyLargeStyle.copyWith(
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
