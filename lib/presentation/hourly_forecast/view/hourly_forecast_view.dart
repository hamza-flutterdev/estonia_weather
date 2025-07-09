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
      drawer: const Drawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
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
                          child: Obx(() {
                            final hourlyData = controller.hourlyData;
                            final currentHourIndex = hourlyData.indexWhere(
                              (hour) => controller.getCurrentHourData() == hour,
                            );

                            // Auto-scroll only if it's today and a valid hour index is found
                            if (controller.isSameDate(
                                  controller.selectedDate.value,
                                  DateTime.now(),
                                ) &&
                                currentHourIndex != -1 &&
                                controller.scrollController.hasClients) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                controller.scrollController.animateTo(
                                  currentHourIndex *
                                      80.0, // Approx height per item
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              });
                            }

                            return ListView.builder(
                              controller: controller.scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: kBodyHp,
                                vertical: kElementInnerGap,
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
                                        ),
                                    padding: kContentPaddingSmall,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
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
                                        WeatherIcon(
                                          iconUrl: hourData['iconUrl'],
                                          size: primaryIcon(context),
                                          weatherData: hourData['condition'],
                                        ),
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
