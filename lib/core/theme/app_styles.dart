import 'package:flutter/material.dart';
import 'app_colors.dart';

const TextStyle headlineLargeStyle = TextStyle(
  fontSize: 124,
  fontWeight: FontWeight.w700,
  color: blackTextColor,
);
const TextStyle headlineMediumStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
  color: blackTextColor,
);
const TextStyle headlineSmallStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);

const TextStyle titleLargeStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);
const TextStyle titleBoldLargeStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: blackTextColor,
);

const TextStyle titleMediumStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);

const TextStyle titleBoldMediumStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: blackTextColor,
);

const TextStyle titleSmallStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);
const TextStyle titleSmallBoldStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: blackTextColor,
);

const TextStyle bodyLargeStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

const TextStyle bodyBoldLargeStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

const TextStyle bodyMediumStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: blackTextColor,
);

const TextStyle bodyBoldMediumStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: blackTextColor,
);

const TextStyle bodySmallStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

const TextStyle bodyBoldSmallStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const TextStyle labelMediumStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);
const TextStyle labelSmallStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: blackTextColor,
);
//decoration
final BoxDecoration roundedDecorationWithShadow = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.5),
      blurRadius: 6,
      spreadRadius: 2,
      offset: Offset(0, 2),
    ),
  ],
);
final BoxDecoration roundedDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.2),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
);
final BoxDecoration roundedNoShadowDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
);

final BoxDecoration roundedPrimaryBorderDecoration = BoxDecoration(
  color: primaryColor.withValues(alpha: 0.7),
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: primaryColor, width: 1.0),
);
