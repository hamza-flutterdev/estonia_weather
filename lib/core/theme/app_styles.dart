import 'package:flutter/material.dart';
import '../constants/constant.dart';
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

TextStyle headlineSmallStyle(BuildContext context) =>
    TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: kWhite);

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
      color: isDarkMode(context) ? darkBgColor : kWhite,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color:
              isDarkMode(context)
                  ? darkBgColor.withValues(alpha: 0.3)
                  : primaryColor.withValues(alpha: 0.3),
          blurRadius: 6,
          spreadRadius: 1,
          offset: Offset(0, 2),
        ),
      ],
    );

BoxDecoration getDynamicBoxDecoration({
  required BuildContext context,
  bool isCurrentHour = false,
  bool isIndexZero = false,
}) {
  final isDark = isDarkMode(context);

  return BoxDecoration(
    color:
        (isCurrentHour || isIndexZero)
            ? null
            : (isDark ? kWhite.withValues(alpha: 0.1) : lightBgColor),
    gradient:
        (isCurrentHour || isIndexZero) ? kContainerGradient(context) : null,
    border: isCurrentHour ? Border.all(color: primaryColor, width: 2) : null,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color:
            isDark
                ? darkBgColor.withValues(alpha: 0.3)
                : primaryColor.withValues(alpha: 0.3),
        blurRadius: 6,
        spreadRadius: 1,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

BoxDecoration roundedSelectionDecoration(
  BuildContext context, {
  required bool isSelected,
}) {
  final isDark = isDarkMode(context);

  return BoxDecoration(
    color:
        isDark
            ? (isSelected
                ? kWhite.withValues(alpha: 0.2)
                : kWhite.withValues(alpha: 0.1))
            : (isSelected ? primaryColor : secondaryColor),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color:
            isDark
                ? darkBgColor.withValues(alpha: 0.3)
                : primaryColor.withValues(alpha: 0.3),
        blurRadius: 6,
        spreadRadius: 1,
        offset: Offset(0, 2),
      ),
    ],
  );
}

Color getBgColor(BuildContext context) =>
    isDarkMode(context) ? darkBgColor : lightBgColor;

Color getTextColor(BuildContext context) =>
    isDarkMode(context) ? kWhite : primaryColor;

Color getSubTextColor(BuildContext context) =>
    isDarkMode(context) ? greyColor : textGreyColorLight;

Color getIconColor(BuildContext context) =>
    isDarkMode(context) ? kWhite : primaryColor;

LinearGradient kGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors:
        isDarkMode(context)
            ? [kWhite.withValues(alpha: 0.08), kWhite.withValues(alpha: 0.06)]
            : [primaryColor, secondaryColor],
    stops: [0.3, 0.95],
  );
}

LinearGradient kContainerGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors:
        isDarkMode(context)
            ? [kWhite.withValues(alpha: 0.2), kWhite.withValues(alpha: 0.1)]
            : [primaryColor, Color.fromARGB(80, 73, 129, 232)],
    stops: [0.3, 0.75],
  );
}
