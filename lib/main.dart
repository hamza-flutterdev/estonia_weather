import 'package:estonia_weather/presentation/home/view/home_view.dart';
import 'package:estonia_weather/presentation/splash/view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart'; // Import DevicePreview
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_manager/appOpen_ads.dart';
import 'ads_manager/interstitial_ads.dart';
import 'core/binders/dependency_injection.dart';
import 'core/constants/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  DependencyInjection.init();
  Get.put(InterstitialAdController());
  Get.put(AppOpenAdController());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    DevicePreview(enabled: false, builder: (context) => const EstoniaWeather()),
  );
}

class EstoniaWeather extends StatelessWidget {
  const EstoniaWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      title: 'Learn English',
      home: const SplashView(),
      theme: ThemeData(fontFamily: fontPrimary),
    );
  }
}
