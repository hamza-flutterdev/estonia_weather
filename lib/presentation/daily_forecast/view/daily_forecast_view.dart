import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/common_widgets/section_header.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/custom_drawer.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/weather_info_card.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../extensions/device_size/device_size.dart';
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
      drawer: CustomDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final deviceSize = DeviceSize(constraints, context);
          final double imageHeight = deviceSize.height * 0.4;
          final double cardTop = deviceSize.height * 0.11;
          final double cardHeight =
              deviceSize.isTab
                  ? deviceSize.height * 0.44
                  : deviceSize.isBig
                  ? deviceSize.height * 0.38
                  : deviceSize.isMedium
                  ? deviceSize.height * 0.44
                  : deviceSize.isSmall
                  ? deviceSize.height * 0.44
                  : deviceSize.height * 0.38;
          final double listItemHeight =
              deviceSize.isTab
                  ? deviceSize.width * 0.15
                  : deviceSize.width * 0.22;

          return SizedBox(
            height: deviceSize.height,
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
                CustomAppBar(
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
                Positioned(
                  top: cardTop,
                  left:
                      deviceSize.isTab
                          ? deviceSize.width * 0.10
                          : deviceSize.width * 0.05,
                  right:
                      deviceSize.isTab
                          ? deviceSize.width * 0.10
                          : deviceSize.width * 0.05,
                  child: SizedBox(
                    height: cardHeight,
                    child: WeatherInfoCard(
                      weatherData: conditionController.mainCityWeather.value,
                      date: selectedDate,
                      temperature: conditionController.temperature,
                      condition: conditionController.condition,
                      minTemp:
                          controller.selectedDayData.minTemp.round().toString(),
                      imagePath: conditionController.weatherIconPath,
                    ),
                  ),
                ),
                Positioned(
                  top:
                      deviceSize.isTab
                          ? cardHeight + kToolbarHeight + kBodyHp * 4
                          : deviceSize.isBig
                          ? cardHeight + kToolbarHeight + kBodyHp
                          : cardHeight + kToolbarHeight + kElementGap,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                deviceSize.isTab
                                    ? deviceSize.width * 0.15
                                    : kBodyHp,
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
                              deviceSize.isTab
                                  ? deviceSize.width * 0.15
                                  : kBodyHp,
                              kBodyHp,
                              deviceSize.isTab
                                  ? deviceSize.width * 0.15
                                  : kBodyHp,
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
                                        color:
                                            index == 0
                                                ? primaryColor
                                                : secondaryColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                  height: listItemHeight,
                                  padding: kContentPaddingSmall,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            deviceSize.isTab
                                                ? deviceSize.width * 0.1
                                                : deviceSize.width * 0.15,
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
                                        width:
                                            deviceSize.isTab
                                                ? deviceSize.width * 0.08
                                                : deviceSize.width * 0.14,
                                      ),
                                      WeatherIcon(
                                        iconUrl: dayData['iconUrl'],
                                        size: primaryIcon(context),
                                        weatherData: dayData['condition'],
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: deviceSize.isTab ? 16 : 8,
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
