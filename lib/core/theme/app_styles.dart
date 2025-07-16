import 'package:flutter/material.dart';
import 'app_colors.dart';

const TextStyle headlineLargeStyle = TextStyle(
  fontSize: 100,
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

const TextStyle titleBoldMediumStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: blackTextColor,
);

const TextStyle titleBoldLargeStyle = TextStyle(
  fontSize: 24,
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

const TextStyle bodyBoldSmallStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

//decoration
final BoxDecoration roundedDecorationWithShadow = BoxDecoration(
  color: kWhite,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.3),
      blurRadius: 6,
      spreadRadius: 1,
      offset: Offset(0, 2),
    ),
  ],
);
