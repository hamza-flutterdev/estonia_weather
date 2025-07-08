import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/common_shimmer.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../daily_forecast/view/daily_forecast_view.dart';
import '../../hourly_forecast/view/hourly_forecast_view.dart';
import '../controller/home_controller.dart';
import '../../../core/common_widgets/section_header.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/model/forecast_model.dart';

class TodayForecastSection extends StatelessWidget {
  const TodayForecastSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final ConditionController conditionController = Get.find();

    return Obx(
      () => Stack(
        children: [
          Positioned(
            top: mobileHeight(context) * 0.47,
            left: mobileWidth(context) * 0.05,
            right: mobileWidth(context) * 0.05,
            child: SectionHeader(
              title: 'Today',
              actionText: '7 Day Forecasts >',
              onTap: () {
                final selectedDate = DateTime.now();
                Get.to(() => ForecastScreen(), arguments: selectedDate);
              },
            ),
          ),
          Positioned(
            top: mobileHeight(context) * 0.51,
            child: SizedBox(
              height: mobileHeight(context) * 0.14,
              width: mobileWidth(context),
              child:
                  homeController.isLoading.value
                      ? ShimmerListView(
                        itemCount: 7,
                        itemWidth: mobileWidth(context) * 0.2,
                        itemHeight: mobileHeight(context) * 0.14,
                        itemMargin:
                            (index) => EdgeInsets.only(
                              left: index == 0 ? kBodyHp : 0,
                              right: index == 6 ? kBodyHp : kElementWidthGap,
                            ),
                        itemDecoration: roundedDecorationWithShadow.copyWith(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeController.forecastData.length,
                        itemBuilder: (context, index) {
                          final forecast = homeController.forecastData[index];
                          final isSelected =
                              index ==
                              homeController.selectedForecastIndex.value;
                          return GestureDetector(
                            onTap: () {
                              homeController.selectForecastDay(index);
                              Get.to(
                                () => const HourlyForecastView(),
                                arguments: DateTime.parse(forecast.date),
                              );
                            },
                            child: TodayForecastCard(
                              day: conditionController.getDayName(
                                forecast.date,
                              ),
                              isSelected: isSelected,
                              isFirst: index == 0,
                              isLast:
                                  index ==
                                  homeController.forecastData.length - 1,
                              forecastData: forecast,
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodayForecastCard extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final ForecastModel? forecastData;

  const TodayForecastCard({
    super.key,
    required this.day,
    required this.isSelected,
    this.isFirst = false,
    this.isLast = false,
    this.forecastData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mobileWidth(context) * 0.2,
      margin: EdgeInsets.only(
        left: isFirst ? kBodyHp : 0,
        right: isLast ? kBodyHp : kElementWidthGap,
      ),
      padding: const EdgeInsets.symmetric(vertical: kElementWidthGap),
      decoration: roundedDecorationWithShadow.copyWith(
        color: isSelected ? primaryColor : primaryColor.withAlpha(100),
        borderRadius: BorderRadius.circular(20),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: titleBoldMediumStyle.copyWith(color: kWhite),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: kElementInnerGap),
            forecastData?.iconUrl.isNotEmpty == true
                ? Image.network(
                  forecastData!.iconUrl,
                  width: secondaryIcon(context),
                  height: secondaryIcon(context),
                  fit: BoxFit.contain,
                )
                : Icon(
                  Icons.wb_sunny,
                  size: secondaryIcon(context),
                  color: kWhite,
                ),
            const SizedBox(height: kElementInnerGap),
            Text(
              forecastData != null
                  ? '${forecastData!.maxTemp.round()}°/${forecastData!.minTemp.round()}°'
                  : '0°/0°',
              style: titleBoldMediumStyle.copyWith(color: kWhite),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
