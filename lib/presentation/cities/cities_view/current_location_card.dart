import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/custom_toast.dart';
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
        await controller.addCurrentLocationToSelected();

        SimpleToast.showCustomToast(
          context: context,
          message: 'Current location is now the main city',
          type: ToastificationType.success,
          primaryColor: primaryColor,
          icon: Icons.location_on,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: kBodyHp * 1.5),
        decoration: roundedDecorationWithShadow.copyWith(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              kOrange.withValues(alpha: 0.9),
              kOrange.withValues(alpha: 0.6),
            ],
            stops: [0.3, 0.85],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.my_location,
                      color: kWhite,
                      size: smallIcon(context),
                    ),
                    const SizedBox(width: kElementWidthGap),
                    Text(
                      'Get Current Location',
                      style: titleSmallBoldStyle.copyWith(color: kWhite),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.add_location,
                color: kWhite,
                size: smallIcon(context) * 0.8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
