// import 'package:flutter/material.dart';
// import '../constants/constant.dart';
// import '../theme/app_colors.dart';
// import '../theme/app_styles.dart';
// import 'icon_buttons.dart';
//
// class SearchBarField extends StatelessWidget {
//   final TextEditingController controller;
//   final void Function(String value) onSearch;
//   final Color backgroundColor;
//   final Color borderColor;
//   final Color iconColor;
//   final Color textColor;
//   final String? fontFamily;
//
//   const SearchBarField({
//     super.key,
//     required this.controller,
//     required this.onSearch,
//     this.backgroundColor = Colors.transparent,
//     this.borderColor = primaryColor,
//     this.iconColor = kWhite,
//     this.textColor = kBlack,
//     this.fontFamily,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CommonTextField(
//       controller: controller,
//       hintText: 'Enter word to search...',
//       textStyle: bodyBoldMediumStyle.copyWith(
//         color: textColor,
//         fontFamily: fontFamily,
//       ),
//       hintStyle: bodyBoldMediumStyle.copyWith(
//         color: textColor,
//         fontFamily: fontFamily,
//       ),
//       cursorColor: textColor,
//       backgroundColor: backgroundColor,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(kCircularBorderRadius),
//         borderSide: BorderSide(color: borderColor),
//       ),
//       onChanged: onSearch,
//       onSubmitted: onSearch,
//       suffixIcon: Padding(
//         padding: const EdgeInsets.all(kElementInnerGap),
//         child: IconActionButton(
//           isCircular: true,
//           backgroundColor: borderColor,
//           icon: Icons.search,
//           color: iconColor,
//           onTap: () {
//             onSearch(controller.text);
//           },
//         ),
//       ),
//     );
//   }
// }
