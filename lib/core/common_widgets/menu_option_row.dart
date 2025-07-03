//
// import 'package:flutter/material.dart';
//
// import '../constants/constant.dart';
// import '../theme/app_styles.dart';
// import 'icon_buttons.dart';
//
// class MenuOptionRow extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final String urduText;
//   final String assetPath;
//   final Color backgroundColor;
//   final VoidCallback onTap;
//   final double? iconSize;
//
//   const MenuOptionRow({
//     super.key,
//     required this.title,
//     this.subtitle,
//     required this.urduText,
//     required this.assetPath,
//     required this.backgroundColor,
//     required this.onTap,
//     this.iconSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           ImageActionButton(
//             padding: EdgeInsets.all(kElementGap),
//             assetPath: assetPath,
//             size: iconSize ?? primaryIcon(context),
//             isCircular: true,
//             backgroundColor: backgroundColor,
//           ),
//           const SizedBox(width: kElementWidthGap),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title, style: titleSmallBoldStyle),
//                   if (subtitle != null) Text(subtitle!, style: bodyMediumStyle),
//                 ],
//               ),
//
//               Text(
//                 urduText,
//                 textAlign: TextAlign.right,
//                 textDirection: TextDirection.rtl,
//                 style: urduBodySmallStyle,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
