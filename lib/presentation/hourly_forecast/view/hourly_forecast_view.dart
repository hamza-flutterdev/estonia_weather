import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:estonia_weather/presentation/hourly_forecast/view/bottom_arc.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final deviceSize = DeviceSize(constraints, context);
          return SizedBox(
            height: deviceSize.height,
            width: double.infinity,
            child: Stack(
              children: [
                ClipPath(
                  clipper: BottomArcClipper(),
                  child: SizedBox(
                    height: deviceSize.hourlyImageHeight,
                    width: double.infinity,
                    child: Image.asset(
                      Assets.images.hourlyForecastBgContainer.path,
                      fit: BoxFit.cover,
                    ),
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
                  top: deviceSize.hourlyCardTop,
                  left: deviceSize.hourlyCardLeftMargin,
                  right: deviceSize.hourlyCardRightMargin,
                  child: Obx(() {
                    final selectedDayData = controller.selectedDayData;
                    if (selectedDayData == null) {
                      return const SizedBox();
                    }
                    return SizedBox(
                      height: deviceSize.hourlyCardHeight,
                      child: WeatherInfoCard(
                        weatherData: conditionController.mainCityWeather.value,
                        forecastData: selectedDayData,
                        date: selectedDate,
                        temperature: selectedDayData.maxTemp.round().toString(),
                        condition: selectedDayData.condition,
                        minTemp: selectedDayData.minTemp.round().toString(),
                        maxTemp: selectedDayData.maxTemp.round().toString(),
                        imagePath: conditionController.weatherIconPath,
                      ),
                    );
                  }),
                ),
                Positioned(
                  top: deviceSize.hourlyListContentTop,
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
                                      (deviceSize.hourlyListItemHeight +
                                          kElementInnerGap),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              });
                            }
                            return ListView.builder(
                              controller: controller.scrollController,
                              padding: EdgeInsets.fromLTRB(
                                deviceSize.hourlyListPaddingHorizontal,
                                kElementInnerGap,
                                deviceSize.hourlyListPaddingHorizontal,
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
                                          color: isCurrentHour ? null : bgColor,
                                          gradient:
                                              isCurrentHour
                                                  ? kContainerGradient
                                                  : null,
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
                                    height: deviceSize.hourlyListItemHeight,
                                    padding: kContentPaddingSmall,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: deviceSize.hourlyTimeWidth,
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
                                          width: deviceSize.hourlySpacerWidth,
                                        ),
                                        WeatherIcon(
                                          iconUrl: hourData['iconUrl'],
                                          size: primaryIcon(context) * 1.25,
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
