import 'package:flutter/material.dart';
import 'app_colors.dart';

TextStyle headlineLargeStyle(BuildContext context) => TextStyle(
  fontSize: 100,
  fontWeight: FontWeight.w700,
  color: getTextColor(context),
);

TextStyle headlineMediumStyle(BuildContext context) => TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
  color: getTextColor(context),
);

TextStyle headlineSmallStyle(BuildContext context) => TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: getTextColor(context),
);

TextStyle titleBoldMediumStyle(BuildContext context) => TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: getTextColor(context),
);

TextStyle titleBoldLargeStyle(BuildContext context) => TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: getTextColor(context),
);

TextStyle titleSmallStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: getTextColor(context),
);

TextStyle titleSmallBoldStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: getTextColor(context),
);

TextStyle bodyLargeStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: getTextColor(context),
);

TextStyle bodyMediumStyle(BuildContext context) => TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: getTextColor(context),
);

TextStyle bodyBoldMediumStyle(BuildContext context) => TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: getTextColor(context),
);

TextStyle bodyBoldSmallStyle(BuildContext context) => TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: getTextColor(context),
);

//decoration
BoxDecoration roundedDecorationWithShadow(BuildContext context) =>
    BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark ? kBlack : kWhite,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.3),
          blurRadius: 6,
          spreadRadius: 1,
          offset: Offset(0, 2),
        ),
      ],
    );
