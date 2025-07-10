import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
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
                  ? deviceSize.height * 0.42
                  : deviceSize.isMedium
                  ? deviceSize.height * 0.48
                  : deviceSize.isSmall
                  ? deviceSize.height * 0.48
                  : deviceSize.height * 0.42;
          final double listItemHeight =
              deviceSize.isTab
                  ? deviceSize.width * 0.12
                  : deviceSize.width * 0.18;

          return SizedBox(
            height: deviceSize.height,
            width: double.infinity,
            child: Stack(
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.asset(
                    Assets.images.hourlyForecastBgContainer.path,
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
                  child: Obx(() {
                    final selectedDayData = controller.selectedDayData;
                    if (selectedDayData == null) {
                      return const SizedBox();
                    }
                    return SizedBox(
                      height: cardHeight,
                      child: WeatherInfoCard(
                        weatherData: conditionController.mainCityWeather.value,
                        forecastData: selectedDayData,
                        date: selectedDate,
                        temperature: selectedDayData.maxTemp.round().toString(),
                        condition: selectedDayData.condition,
                        minTemp: selectedDayData.minTemp.round().toString(),
                        imagePath: conditionController.weatherIconPath,
                      ),
                    );
                  }),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: kElementGap),
                        Expanded(
                          child: Obx(() {
                            final hourlyData = controller.hourlyData;
                            final currentHourIndex = hourlyData.indexWhere(
                              (hour) => controller.getCurrentHourData() == hour,
                            );
                            if (controller.isSameDate(
                                  controller.selectedDate.value,
                                  DateTime.now(),
                                ) &&
                                currentHourIndex != -1 &&
                                controller.scrollController.hasClients) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                controller.scrollController.animateTo(
                                  currentHourIndex *
                                      (listItemHeight + kElementInnerGap),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              });
                            }
                            return ListView.builder(
                              controller: controller.scrollController,
                              padding: EdgeInsets.fromLTRB(
                                deviceSize.isTab
                                    ? deviceSize.width * 0.15
                                    : kBodyHp,
                                kElementInnerGap,
                                deviceSize.isTab
                                    ? deviceSize.width * 0.15
                                    : kBodyHp,
                                0,
                              ),
                              itemCount: hourlyData.length,
                              itemBuilder: (context, index) {
                                final hourData = hourlyData[index];
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
                                                  ? primaryColor
                                                  : secondaryColor,
                                          border:
                                              isCurrentHour
                                                  ? Border.all(
                                                    color: primaryColor,
                                                    width: 2,
                                                  )
                                                  : null,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                    height: listItemHeight,
                                    padding: kContentPaddingSmall,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              deviceSize.isTab
                                                  ? deviceSize.width * 0.1
                                                  : deviceSize.width * 0.15,
                                          child: Text(
                                            time,
                                            style: bodyMediumStyle.copyWith(
                                              color:
                                                  isCurrentHour
                                                      ? kWhite
                                                      : primaryColor,
                                              fontWeight:
                                                  isCurrentHour
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
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
                                          iconUrl: hourData['iconUrl'],
                                          size: primaryIcon(context),
                                          weatherData: hourData['condition'],
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${hourData['temp_c'].round()}°',
                                          style: headlineSmallStyle.copyWith(
                                            color:
                                                isCurrentHour
                                                    ? kWhite
                                                    : primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
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
