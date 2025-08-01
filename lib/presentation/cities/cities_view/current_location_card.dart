import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../controller/cities_controller.dart';

class CurrentLocationCard extends StatelessWidget {
  final CitiesController controller;

  const CurrentLocationCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await controller.addCurrentLocationToSelected(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: kBodyHp * 1.5),
        decoration: roundedDecorationWithShadow(context).copyWith(
          gradient: kContainerGradient(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
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
                        Icon(
                          Icons.my_location,
                          color: kWhite,
                          size: smallIcon(context),
                        ),
                        const SizedBox(width: kElementWidthGap),
                        Expanded(
                          child: Text(
                            'Get Current Location',
                            style: titleSmallBoldStyle(
                              context,
                            ).copyWith(color: kWhite),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      final currentCity =
                          controller.homeController.currentLocationCity;

                      if (currentCity != null) {
                        final weather = controller
                            .homeController
                            .conditionController
                            .selectedCitiesWeather
                            .firstWhereOrNull(
                              (w) => w.cityName == currentCity.city,
                            );

                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "${currentCity.city}/${weather?.region ?? ''}",
                            style: bodyLargeStyle(
                              context,
                            ).copyWith(color: kWhite.withValues(alpha: 0.9)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              Icon(Icons.add_location, color: kWhite, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
