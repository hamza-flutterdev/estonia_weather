// import 'package:flutter/material.dart';
//
// import 'app_colors.dart';
// import 'app_styles.dart';
//
// abstract class AppTheme {
//   static const fontFamily = 'Montserrat';
//
//   // BUTTON STYLES
//   static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
//     backgroundColor: secondaryColor,
//     textStyle: buttonTextStyle,
//     foregroundColor: Colors.white,
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//     minimumSize: const Size(double.maxFinite, 50),
//     shadowColor: Colors.grey.withValues(alpha: 0.5),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   );
//
//   static final ButtonStyle textButtonStyle = TextButton.styleFrom(
//     backgroundColor: kWhite,
//     textStyle: buttonTextStyle,
//     foregroundColor: kBlack,
//     elevation: 4,
//     shadowColor: Colors.grey.withValues(alpha: 0.5),
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//     minimumSize: const Size(double.maxFinite, 50),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   );
//
//   static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
//     backgroundColor: Colors.transparent,
//     textStyle: buttonTextStyle,
//     foregroundColor: kBlack,
//     padding: EdgeInsets.zero,
//     side: BorderSide.none,
//   );
//
//   static final confirmButtonStyle = TextButton.styleFrom(
//     foregroundColor: kRed,
//     backgroundColor: Colors.transparent,
//     textStyle: labelMediumStyle,
//     minimumSize: Size(10, 10),
//     padding: EdgeInsets.only(bottom: 20),
//   );
//
//   static const UnderlineInputBorder greyUnderLineBorder = UnderlineInputBorder(
//     borderSide: BorderSide(color: greyBorderColor),
//   );
//
//   // FINAL THEME DATA
//   static final ThemeData themeData = ThemeData(
//     fontFamily: fontFamily,
//     scaffoldBackgroundColor: bgColor,
//     textTheme: const TextTheme(
//       headlineSmall: headlineSmallStyle,
//       headlineMedium: headlineMediumStyle,
//       titleLarge: titleLargeStyle,
//       titleMedium: titleMediumStyle,
//       titleSmall: titleSmallStyle,
//       bodyLarge: bodyLargeStyle,
//       bodyMedium: bodyMediumStyle,
//       bodySmall: bodySmallStyle,
//       labelMedium: labelMediumStyle,
//       labelSmall: labelSmallStyle,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       contentPadding: EdgeInsets.zero,
//       border: greyUnderLineBorder,
//       enabledBorder: greyUnderLineBorder,
//       focusedBorder: greyUnderLineBorder,
//       errorBorder: greyUnderLineBorder.copyWith(
//         borderSide: BorderSide(color: kRed),
//       ),
//       focusedErrorBorder: greyUnderLineBorder,
//       hintStyle: bodyMediumStyle.copyWith(color: textGreyColor),
//       fillColor: Colors.white,
//       filled: true,
//       suffixIconColor: suffixIconColor,
//       prefixIconColor: suffixIconColor,
//     ),
//     textSelectionTheme: TextSelectionThemeData(
//       cursorColor: kBlack,
//       selectionColor: greyColor.withValues(alpha: 0.2),
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: appBarBgColor,
//       titleTextStyle: titleLargeStyle,
//       iconTheme: IconThemeData(color: Colors.black),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
//     textButtonTheme: TextButtonThemeData(style: textButtonStyle),
//     outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
//     drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
//     cardTheme: CardThemeData(color: kWhite, elevation: 3),
//     tabBarTheme: TabBarThemeData(
//       unselectedLabelColor: Colors.black,
//       dividerColor: Colors.transparent,
//       labelColor: Colors.white,
//       indicatorSize: TabBarIndicatorSize.tab,
//       labelStyle: bodySmallStyle,
//       unselectedLabelStyle: bodySmallStyle,
//       indicator: BoxDecoration(
//         color: secondaryColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),
//   );
// }
