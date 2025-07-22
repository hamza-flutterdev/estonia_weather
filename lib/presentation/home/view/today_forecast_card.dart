import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/common_shimmer.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../extensions/device_size/device_size.dart';
import '../../hourly_forecast/view/hourly_forecast_view.dart';
import '../controller/home_controller.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/model/forecast_model.dart';

class TodayForecastSection extends StatelessWidget {
  final DeviceSize deviceSize;

  const TodayForecastSection({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final ConditionController conditionController = Get.find();

    return Obx(
      () => Stack(
        children: [
          SizedBox(
            height: deviceSize.height * 0.14,
            width: deviceSize.width,
            child:
                homeController.isLoading.value
                    ? ShimmerListView(
                      itemCount: 7,
                      itemWidth: deviceSize.width * 0.2,
                      itemHeight: deviceSize.height * 0.14,
                      itemMargin:
                          (index) => EdgeInsets.only(
                            left: index == 0 ? kBodyHp : 0,
                            right: index == 6 ? kBodyHp : kElementWidthGap,
                          ),
                      itemDecoration: roundedDecorationWithShadow(
                        context,
                      ).copyWith(borderRadius: BorderRadius.circular(20)),
                    )
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: homeController.forecastData.length,
                      itemBuilder: (context, index) {
                        final forecast = homeController.forecastData[index];
                        final isSelected =
                            index == homeController.selectedForecastIndex.value;
                        return GestureDetector(
                          onTap: () {
                            homeController.selectDay(0);
                            Get.to(
                              () => const HourlyForecastView(),
                              arguments: DateTime.parse(forecast.date),
                            );
                          },
                          child: TodayForecastCard(
                            day: conditionController.getDayName(forecast.date),
                            isSelected: isSelected,
                            isFirst: index == 0,
                            isLast:
                                index == homeController.forecastData.length - 1,
                            forecastData: forecast,
                            deviceSize: deviceSize,
                          ),
                        );
                      },
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
  final DeviceSize deviceSize;

  const TodayForecastCard({
    super.key,
    required this.day,
    required this.isSelected,
    this.isFirst = false,
    this.isLast = false,
    this.forecastData,
    required this.deviceSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceSize.width * 0.2,
      margin: EdgeInsets.only(
        left: isFirst ? kBodyHp : 0,
        right: isLast ? kBodyHp : kElementGap,
      ),
      padding: const EdgeInsets.symmetric(vertical: kBodyHp),
      decoration: roundedSelectionDecoration(context, isSelected: isSelected),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                day,
                style: titleSmallBoldStyle(context).copyWith(color: kWhite),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: kElementInnerGap),
            forecastData?.iconUrl.isNotEmpty == true
                ? Image.network(
                  forecastData!.iconUrl,
                  width: primaryIcon(context),
                  height: primaryIcon(context),
                  fit: BoxFit.contain,
                )
                : Icon(
                  Icons.wb_sunny,
                  size: primaryIcon(context),
                  color: kWhite,
                ),
            const SizedBox(height: kElementInnerGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                forecastData != null
                    ? '${forecastData!.maxTemp.round()}°/${forecastData!.minTemp.round()}°'
                    : '0°/0°',
                style: titleSmallBoldStyle(context).copyWith(color: kWhite),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
