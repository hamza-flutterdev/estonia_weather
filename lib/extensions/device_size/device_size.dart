import 'package:flutter/material.dart';
import '../../core/constants/constant.dart';

class DeviceSize {
  final BoxConstraints constraints;
  final BuildContext context;

  DeviceSize(this.constraints, this.context);

  double get width => constraints.maxWidth;
  double get height => constraints.maxHeight;

  bool get isSmall => height < 675;
  bool get isMedium => height >= 675 && height < 780;
  bool get isBig => height >= 875;
  bool get isTab => width >= 600;

  // Existing constants
  double get horizontalPadding => isTab ? width * 0.08 : width * 0.05;
  double get weatherCardHorizontalMargin => isTab ? width * 0.2 : width * 0.15;
  double get weatherIconLeft => isTab ? width * 0.12 : width * 0.08;
  double get weatherIconTop =>
      isTab
          ? height * 0.1
          : isSmall
          ? height * 0.29
          : isMedium
          ? height * 0.24
          : isBig
          ? height * 0.24
          : height * 0.21;
  double get weatherIconSize => largeIcon(context);
  double get detailsCardTop =>
      isTab
          ? height * 0.34
          : isSmall
          ? height * 0.50
          : isMedium
          ? height * 0.445
          : isBig
          ? height * 0.38
          : height * 0.40;
  double get todayHeaderTop =>
      isTab
          ? height * 0.46
          : isSmall
          ? height * 0.615
          : isMedium
          ? height * 0.57
          : isBig
          ? height * 0.50
          : height * 0.535;
  double get todayForecastTop =>
      isTab
          ? height * 0.49
          : isSmall
          ? height * 0.65
          : isMedium
          ? height * 0.608
          : isBig
          ? height * 0.53
          : height * 0.57;
  double get otherCitiesHeaderTop =>
      isTab
          ? height * 0.65
          : isSmall
          ? height * 0.79
          : isMedium
          ? height * 0.755
          : isBig
          ? height * 0.68
          : height * 0.735;
  double get otherCitiesTop =>
      isTab
          ? height * 0.68
          : isSmall
          ? height * 0.84
          : isMedium
          ? height * 0.80
          : isBig
          ? height * 0.71
          : height * 0.78;

  // Hourly Forecast Layout Constants
  double get hourlyImageHeight => height * 0.4;
  double get hourlyCardTop => height * 0.11;
  double get hourlyCardHeight =>
      isTab
          ? height * 0.44
          : isBig
          ? height * 0.42
          : isMedium
          ? height * 0.48
          : isSmall
          ? height * 0.48
          : height * 0.42;
  double get hourlyListItemHeight => isTab ? width * 0.12 : width * 0.18;
  double get hourlyCardLeftMargin => isTab ? width * 0.10 : width * 0.05;
  double get hourlyCardRightMargin => isTab ? width * 0.10 : width * 0.05;
  double get hourlyListContentTop =>
      isTab
          ? hourlyCardHeight + kToolbarHeight + kBodyHp * 4
          : isBig
          ? hourlyCardHeight + kToolbarHeight + kBodyHp
          : hourlyCardHeight + kToolbarHeight + kElementGap;
  double get hourlyListPaddingHorizontal => isTab ? width * 0.15 : kBodyHp;
  double get hourlyTimeWidth => isTab ? width * 0.1 : width * 0.15;
  double get hourlySpacerWidth => isTab ? width * 0.08 : width * 0.14;

  // Daily Forecast Layout Constants
  double get dailyImageHeight => height * 0.4;
  double get dailyCardTop => height * 0.11;
  double get dailyCardHeight =>
      isTab
          ? height * 0.44
          : isBig
          ? height * 0.40
          : isMedium
          ? height * 0.44
          : isSmall
          ? height * 0.44
          : height * 0.38;
  double get dailyListItemHeight => isTab ? width * 0.15 : width * 0.22;
  double get dailyCardLeftMargin => isTab ? width * 0.10 : width * 0.05;
  double get dailyCardRightMargin => isTab ? width * 0.10 : width * 0.05;
  double get dailyListContentTop =>
      isTab
          ? dailyCardHeight + kToolbarHeight + kBodyHp * 4
          : isBig
          ? dailyCardHeight + kToolbarHeight + kBodyHp
          : dailyCardHeight + kToolbarHeight + kElementGap;
  double get dailyListPaddingHorizontal => isTab ? width * 0.15 : kBodyHp;
  double get dailyDayWidth => isTab ? width * 0.1 : width * 0.15;
  double get dailySpacerWidth => isTab ? width * 0.08 : width * 0.14;
  double get dailyConditionPaddingLeft => isTab ? 16.0 : 8.0;
}
