import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:estonia_weather/presentation/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/custom_toast.dart';
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
    final homeController = Get.find<HomeController>();
    return Obx(() {
      final isCurrentLocationCity = homeController.isLocationCity(city);

      return GestureDetector(
        onTap: () async {
          SimpleToast.showCustomToast(
            context: context,
            message: '${city.city} is now your main city',
            type: ToastificationType.success,
            primaryColor: primaryColor,
            icon: Icons.home,
          );
          await controller.makeCityMain(city);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: kElementGap),
          decoration: roundedDecorationWithShadow(context).copyWith(
            gradient: kContainerGradient(context),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            weather.cityName,
                            style: titleSmallBoldStyle(
                              context,
                            ).copyWith(color: kWhite),
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
                        style: bodyMediumStyle(context).copyWith(color: kWhite),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature.round()}°',
                        style: headlineMediumStyle(
                          context,
                        ).copyWith(color: kWhite),
                      ),
                      Text(
                        weather.condition,
                        style: bodyMediumStyle(context).copyWith(color: kWhite),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
