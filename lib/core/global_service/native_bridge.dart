// import 'package:flutter/services.dart';
//
// class NativeBridge {
//   static const platform = MethodChannel('com.example/native');
//
//   static Future<String?> getBatteryLevel() async {
//     try {
//       final String? result = await platform.invokeMethod('getBatteryLevel');
//       return result;
//     } on PlatformException catch (e) {
//       return "Failed to get battery level: '${e.message}'.";
//     }
//   }
// }
