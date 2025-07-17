import 'package:estonia_weather/ads_manager/banner_ads.dart';
import 'package:estonia_weather/presentation/splash/view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ads_manager/appOpen_ads.dart';
import 'ads_manager/interstitial_ads.dart';
import 'ads_manager/onesignal.dart';
import 'ads_manager/splash_interstitial.dart';
import 'core/binders/dependency_injection.dart';
import 'core/constants/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  Get.put(AppOpenAdController());
  DependencyInjection.init();
  Get.put(SplashInterstitialAdController());
  Get.put(BannerAdController());
  Get.put(InterstitialAdController());
  initializeOneSignal();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const EstoniaWeather());
}

class EstoniaWeather extends StatelessWidget {
  const EstoniaWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Estonia Weather',
      theme: ThemeData(fontFamily: fontPrimary),
      home: const SplashView(),
    );
  }
}
