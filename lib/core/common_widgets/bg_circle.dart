//
// import 'package:flutter/material.dart';
//
// import '../constants/constant.dart';
// import '../theme/app_colors.dart';
//
// class AppbarCircle extends StatelessWidget {
//   const AppbarCircle({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: -mobileHeight(context) * 0.4,
//       left: -mobileWidth(context) * 0.5,
//       child: Container(
//         width: mobileWidth(context) * 2,
//         height: mobileHeight(context),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [primaryColor.withValues(alpha: 0.2), primaryColor],
//           ),
//         ),
//       ),
//     );
//   }
// }
