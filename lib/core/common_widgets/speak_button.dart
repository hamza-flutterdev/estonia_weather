// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../tts/tts_controller.dart';
// import 'icon_buttons.dart';
//
// class SpeakButton extends StatelessWidget {
//   final String textToSpeak;
//   final String? message;
//   final Color color;
//   final double size;
//   final VoidCallback? onSpeakPressed;
//
//   const SpeakButton({
//     super.key,
//     required this.textToSpeak,
//     this.message = 'Speak Word',
//     required this.color,
//     required this.size,
//     this.onSpeakPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final TTSController tts =
//         Get.isRegistered<TTSController>()
//             ? Get.find()
//             : Get.put(TTSController());
//
//     return Obx(
//       () => Tooltip(
//         message:
//             tts.isSpeaking(textToSpeak)
//                 ? 'Stop Speaking'
//                 : (message ?? 'Speak Word'),
//         child: IconActionButton(
//           onTap: () {
//             if (tts.isSpeaking(textToSpeak)) {
//               tts.stop();
//             } else {
//               tts.speak(textToSpeak);
//               if (onSpeakPressed != null) {
//                 onSpeakPressed!();
//               }
//             }
//           },
//           icon:
//               tts.isSpeaking(textToSpeak)
//                   ? Icons.stop_circle
//                   : Icons.play_circle,
//           color: color,
//           size: size,
//         ),
//       ),
//     );
//   }
// }
