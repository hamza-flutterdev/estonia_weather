import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/constant.dart';
import '../controller/daily_forecast_controller.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForecastController controller = Get.find<ForecastController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: controller.mainCityName.value,
        subtitle: '7-day forecast',
        useBackButton: true,
      ),
      body: Column(
        children: [
          // Selected Day Weather Details
          Container(
            margin: const EdgeInsets.all(kBodyHp),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, secondaryColor],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(kBodyHp * 1.5),
              child: Obx(
                () => Column(
                  children: [
                    // Day and Date
                    Text(
                      controller.selectedDayData['day'],
                      style: headlineMediumStyle.copyWith(color: kWhite),
                    ),
                    Text(
                      controller.selectedDayData['date'],
                      style: bodyLargeStyle.copyWith(
                        color: kWhite.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: kBodyHp),

                    // Weather Icon and Temperature
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          controller.getWeatherIcon(
                            controller.selectedDayData['condition'],
                          ),
                          width: largeIcon(context) * 1.5,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.cloud,
                              color: kWhite,
                              size: largeIcon(context) * 1.5,
                            );
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              '${controller.selectedDayData['temp']}°',
                              style: headlineLargeStyle.copyWith(
                                color: kWhite,
                                fontSize: 48,
                              ),
                            ),
                            Text(
                              'H: ${controller.selectedDayData['temp']}° L: ${controller.selectedDayData['minTemp']}°',
                              style: bodyLargeStyle.copyWith(
                                color: kWhite.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: kBodyHp),

                    // Weather Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ForecastDetailItem(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: '${controller.selectedDayData['humidity']}%',
                        ),
                        ForecastDetailItem(
                          icon: Icons.air,
                          label: 'Wind',
                          value:
                              '${controller.selectedDayData['windSpeed']}km/h',
                        ),
                        ForecastDetailItem(
                          icon: Icons.grain,
                          label: 'Rain',
                          value:
                              '${controller.selectedDayData['precipitation']}mm',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 7-Day Forecast List
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: kBodyHp),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.all(kBodyHp),
                  itemCount: controller.forecastData.length,
                  itemBuilder: (context, index) {
                    final forecast = controller.forecastData[index];
                    final isSelected =
                        index == controller.selectedDayIndex.value;

                    return GestureDetector(
                      onTap: () => controller.selectDay(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: kElementGap),
                        padding: const EdgeInsets.all(kBodyHp),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected ? primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Day
                            SizedBox(
                              width: 80,
                              child: Text(
                                forecast['day'],
                                style: titleBoldMediumStyle.copyWith(
                                  color:
                                      isSelected ? primaryColor : Colors.black,
                                ),
                              ),
                            ),

                            // Weather Icon
                            Image.asset(
                              controller.getWeatherIcon(forecast['condition']),
                              width: primaryIcon(context),
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.cloud,
                                  color: isSelected ? primaryColor : greyColor,
                                  size: primaryIcon(context),
                                );
                              },
                            ),

                            const SizedBox(width: kBodyHp),

                            // Condition
                            Expanded(
                              child: Text(
                                forecast['condition'].toString().capitalize ??
                                    '',
                                style: bodyMediumStyle.copyWith(
                                  color:
                                      isSelected ? primaryColor : Colors.black,
                                ),
                              ),
                            ),

                            // Temperature Range
                            Row(
                              children: [
                                Text(
                                  '${forecast['minTemp']}°',
                                  style: bodyMediumStyle.copyWith(
                                    color:
                                        isSelected
                                            ? primaryColor.withOpacity(0.7)
                                            : greyColor,
                                  ),
                                ),
                                const SizedBox(width: kElementWidthGap),
                                Container(
                                  width: 50,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.withOpacity(0.3),
                                        Colors.orange.withOpacity(0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: kElementWidthGap),
                                Text(
                                  '${forecast['temp']}°',
                                  style: titleBoldMediumStyle.copyWith(
                                    color:
                                        isSelected
                                            ? primaryColor
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: kBodyHp),
        ],
      ),
    );
  }
}

class ForecastDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ForecastDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: kWhite, size: primaryIcon(context)),
        const SizedBox(height: kElementInnerGap),
        Text(value, style: titleBoldMediumStyle.copyWith(color: kWhite)),
        Text(
          label,
          style: bodyMediumStyle.copyWith(color: kWhite.withOpacity(0.8)),
        ),
      ],
    );
  }
}
