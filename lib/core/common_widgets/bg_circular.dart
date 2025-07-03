// import 'package:flutter/material.dart';
//
// class BackgroundCircles extends StatelessWidget {
//   const BackgroundCircles({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           top: -150,
//           left: -100,
//           child: Container(
//             width: 400,
//             height: 350,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   Color(0xFF569CD4),
//                   Color(0xFF35BEAE),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         // Right circle with 212° gradient
//         Positioned(
//           top: -100,
//           right: -80,
//           child: Container(
//             width: 320,
//             height: 350,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   Color(0xFF35BEAE),
//                   Color(0xFF569CD4),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
