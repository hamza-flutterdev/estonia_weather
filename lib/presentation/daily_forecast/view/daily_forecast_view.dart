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
import '../../../extensions/device_size/device_size.dart';
import '../../../gen/assets.gen.dart';
import '../../cities/cities_view/cities_view.dart';
import '../../../core/common_widgets/weather_icon.dart';
import '../controller/daily_forecast_controller.dart';

class DailyForecastView extends StatelessWidget {
  const DailyForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = Get.arguments;
    final DailyForecastController controller =
        Get.find<DailyForecastController>();
    final ConditionController conditionController =
        Get.find<ConditionController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final deviceSize = DeviceSize(constraints, context);

          return SizedBox(
            height: deviceSize.height,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: deviceSize.dailyImageHeight,
                  width: double.infinity,
                  child: Image.asset(
                    Assets.images.dailyForecastBgContainer.path,
                    fit: BoxFit.cover,
                  ),
                ),
                CustomAppBar(
                  actions: [
                    IconActionButton(
                      onTap: () => Get.to(CitiesView()),
                      icon: Icons.add,
                      color: primaryColor,
                      size: secondaryIcon(context),
                    ),
                  ],
                  subtitle: '',
                ),
                Positioned(
                  top: deviceSize.dailyCardTop,
                  left: deviceSize.dailyCardLeftMargin,
                  right: deviceSize.dailyCardRightMargin,
                  child: SizedBox(
                    height: deviceSize.dailyCardHeight,
                    child: WeatherInfoCard(
                      weatherData: conditionController.mainCityWeather.value,
                      date: selectedDate,
                      temperature: conditionController.temperature,
                      maxTemp: conditionController.maxTemp,
                      condition: conditionController.condition,
                      minTemp:
                          controller.selectedDayData?.minTemp
                              .round()
                              .toString() ??
                          '--',

                      imagePath: conditionController.weatherIconPath,
                    ),
                  ),
                ),
                Positioned(
                  top: deviceSize.dailyListContentTop,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceSize.dailyListPaddingHorizontal,
                          ),
                          child: SectionHeader(
                            actionIcon: Icons.location_on,
                            title: '7 Day Forecasts',
                            actionText: controller.mainCityName.toString(),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(
                              deviceSize.dailyListPaddingHorizontal,
                              kElementInnerGap,
                              deviceSize.dailyListPaddingHorizontal,
                              0,
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
                                        gradient:
                                            index == 0
                                                ? kContainerGradient
                                                : null,
                                        color: index == 0 ? null : bgColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                  height: deviceSize.dailyListItemHeight,
                                  padding: kContentPaddingSmall,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: deviceSize.dailyDayWidth,
                                        child: Text(
                                          dayData['day'],
                                          style: bodyLargeStyle.copyWith(
                                            color:
                                                index == 0
                                                    ? kWhite
                                                    : primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: deviceSize.dailySpacerWidth,
                                      ),
                                      WeatherIcon(
                                        iconUrl: dayData['iconUrl'],
                                        size: primaryIcon(context) * 1.25,
                                        weatherData: dayData['condition'],
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left:
                                                deviceSize
                                                    .dailyConditionPaddingLeft,
                                          ),
                                          child: Text(
                                            dayData['condition'],
                                            style: bodyLargeStyle.copyWith(
                                              color:
                                                  index == 0
                                                      ? kWhite
                                                      : primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${dayData['temp'].round()}° / ${dayData['minTemp'].round()}°',
                                        style: bodyLargeStyle.copyWith(
                                          color:
                                              index == 0
                                                  ? kWhite
                                                  : primaryColor,
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
