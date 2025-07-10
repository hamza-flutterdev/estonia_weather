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

  double get horizontalPadding => isTab ? width * 0.08 : width * 0.05;

  double get weatherCardHorizontalMargin => isTab ? width * 0.2 : width * 0.15;

  double get weatherIconLeft => isTab ? width * 0.12 : width * 0.08;

  double get weatherIconTop =>
      isTab
          ? height * 0.1
          : isSmall
          ? height * 0.29
          : isMedium
          ? height * 0.28
          : isBig
          ? height * 0.24
          : height * 0.23;

  double get weatherIconSize => largeIcon(context);

  double get detailsCardTop =>
      isTab
          ? height * 0.34
          : isSmall
          ? height * 0.50
          : isMedium
          ? height * 0.45
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
          ? height * 0.605
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
}
