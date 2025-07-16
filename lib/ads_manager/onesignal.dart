import 'dart:io';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void initializeOneSignal() {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  if (Platform.isAndroid) {
    OneSignal.initialize("f7c3a91b-c522-4730-a7bd-2554bd9d1822");
    OneSignal.Notifications.requestPermission(true);
  } else if (Platform.isIOS) {
    OneSignal.initialize(" ");
    OneSignal.Notifications.requestPermission(true);
  } else {
    print("Unsupported platform for OneSignal");
  }
}