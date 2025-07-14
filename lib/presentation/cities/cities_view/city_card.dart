import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/custom_toast.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../controller/cities_controller.dart';

class CityCard extends StatelessWidget {
  final CitiesController controller;
  final dynamic weather;
  final dynamic city;

  const CityCard({
    super.key,
    required this.controller,
    required this.weather,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.isCitySelected(city);
      final canRemove = controller.canRemoveSpecificCity(city);
      final canAdd = controller.canAddCity();
      final isCurrentLocationCity = controller.isCurrentLocationCity(city);

      return Container(
        margin: const EdgeInsets.only(bottom: kElementGap),
        decoration: roundedDecorationWithShadow.copyWith(
          gradient: kContainerGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          weather.cityName,
                          style: titleSmallBoldStyle.copyWith(color: kWhite),
                        ),
                        const SizedBox(width: kElementWidthGap),
                        Icon(
                          isCurrentLocationCity
                              ? Icons.my_location
                              : Icons.location_on,
                          color: kWhite,
                          size: smallIcon(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: kElementInnerGap),
                    Text(
                      controller.getAqiText(weather.airQuality),
                      style: bodyMediumStyle.copyWith(color: kWhite),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${weather.temperature.round()}°',
                    style: headlineMediumStyle.copyWith(color: kWhite),
                  ),
                  Text(
                    weather.condition,
                    style: bodyMediumStyle.copyWith(color: kWhite),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: kElementGap),
                child: IconActionButton(
                  backgroundColor: kWhite,
                  isCircular: true,
                  icon: isSelected ? Icons.remove : Icons.add,
                  color: primaryColor,
                  size: smallIcon(context) * 0.6,
                  onTap: () async {
                    if (isSelected) {
                      // Remove city
                      if (isCurrentLocationCity) {
                        SimpleToast.showCustomToast(
                          context: context,
                          message: 'Current location cannot be removed',
                          type: ToastificationType.warning,
                          primaryColor: kOrange,
                          icon: Icons.warning,
                        );
                        return;
                      }

                      if (canRemove) {
                        await controller.removeCityFromSelected(city);
                        SimpleToast.showCustomToast(
                          context: context,
                          message: '${city.city} has been removed',
                          type: ToastificationType.warning,
                          primaryColor: kOrange,
                          icon: Icons.remove_circle_outline,
                        );
                      } else {
                        SimpleToast.showCustomToast(
                          context: context,
                          message: 'A minimum of 2 cities are required',
                          type: ToastificationType.warning,
                          primaryColor: kOrange,
                          icon: Icons.remove_circle_outline,
                        );
                      }
                    } else {
                      if (canAdd) {
                        await controller.addCityToSelected(city);
                        SimpleToast.showCustomToast(
                          context: context,
                          message: '${city.city} has been added',
                          type: ToastificationType.info,
                          primaryColor: primaryColor,
                          icon: Icons.add_circle_outline,
                        );
                      } else {
                        SimpleToast.showCustomToast(
                          context: context,
                          message: 'Maximum number of cities reached',
                          type: ToastificationType.error,
                          primaryColor: kRed,
                          icon: Icons.error,
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
