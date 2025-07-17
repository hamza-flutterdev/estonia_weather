import 'dart:io';
import 'dart:math';
import 'package:estonia_weather/ads_manager/splash_interstitial.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

import 'appOpen_ads.dart';
import 'interstitial_ads.dart';

class NativeAdController extends GetxController {
  NativeAd? _nativeAd;
  bool isAdReady = false;
  bool showAd = false;
  final Rx<Widget> adWidget = Rx<Widget>(SizedBox.shrink());
  final AppOpenAdController openAdController = Get.put(AppOpenAdController());
  final InterstitialAdController interAds = Get.put(InterstitialAdController());
  final SplashInterstitialAdController spAds = Get.put(
    SplashInterstitialAdController(),
  );

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
  }

  Future<void> initializeRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
      final key = Platform.isAndroid ? 'NativeAdv' : 'NativeAdvAd';
      showAd = remoteConfig.getBool(key);
      if (showAd) {
        loadNativeAd();
      }
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }

  void loadNativeAd() {
    final unitId =
        Platform.isAndroid
            ? 'ca-app-pub-3118392277684870/8301439454'
            : 'ca-app-pub-5405847310750111/9804849545';
    _nativeAd = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          isAdReady = true;
          updateAdWidget();
        },
        onAdFailedToLoad: (ad, error) {
          isAdReady = false;
          ad.dispose();
          updateAdWidget();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        mainBackgroundColor: Colors.white,
        templateType: TemplateType.small,
      ),
    );

    _nativeAd!.load();
  }

  void updateAdWidget() {
    final screenHeight = MediaQuery.of(Get.context!).size.height;
    final adHeight = screenHeight * 0.14;
    if (isAdReady && _nativeAd != null) {
      adWidget.value = Container(
        height: adHeight,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      adWidget.value = shimmerWidget(adHeight);
    }
  }

  Widget shimmerWidget(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Image
            AspectRatio(
              aspectRatio: 55 / 15,
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // First Text Line
            Container(
              width: double.infinity,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: width * 0.7,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nativeAdWidget() {
    if (openAdController.isShowingOpenAd.value) {
      return const SizedBox();
    } else {
      return Obx(() => adWidget.value);
    }
  }

  @override
  void onClose() {
    _nativeAd?.dispose();
    super.onClose();
  }
}

class NativeAdMeduimController extends GetxController {
  NativeAd? _nativeAd;
  bool isAdReady = false;
  bool showAd = false;
  final Rx<Widget> adWidget = Rx<Widget>(SizedBox.shrink());
  final AppOpenAdController openAdController = Get.put(AppOpenAdController());
  final InterstitialAdController interAds = Get.put(InterstitialAdController());
  final SplashInterstitialAdController spAds = Get.put(
    SplashInterstitialAdController(),
  );

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
  }

  Future<void> initializeRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
      final key = Platform.isAndroid ? 'NativeAdvAd' : 'NativeAdv';
      showAd = remoteConfig.getBool(key);
      if (showAd) {
        loadNativeAd();
      }
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }

  void loadNativeAd() {
    final unitId =
        Platform.isAndroid
            ? 'ca-app-pub-8172082069591999/6795197344'
            : 'ca-app-pub-5405847310750111/6074665121';
    _nativeAd = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          isAdReady = true;
          updateAdWidget();
        },
        onAdFailedToLoad: (ad, error) {
          isAdReady = false;
          ad.dispose();
          updateAdWidget();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        mainBackgroundColor: Colors.white,
        templateType: TemplateType.medium,
      ),
    );

    _nativeAd!.load();
  }

  void updateAdWidget() {
    final screenHeight = MediaQuery.of(Get.context!).size.height;
    final adHeight = min(screenHeight * 0.37, 350.0);

    if (isAdReady && _nativeAd != null) {
      adWidget.value = Container(
        height: 300,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      adWidget.value = shimmerWidget(adHeight);
    }
  }

  Widget shimmerWidget(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 20 / 8,
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // First Text Line - taller
            Container(
              width: double.infinity,
              height: 20, // increased height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 14), // more spacing
            // Second Text Line - also taller
            Container(
              width: width * 0.7,
              height: 20, // increased height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nativeAdWidget() {
    if (openAdController.isShowingOpenAd.value) {
      return const SizedBox();
    } else {
      return Obx(() => adWidget.value);
    }
  }

  @override
  void onClose() {
    _nativeAd?.dispose();
    super.onClose();
  }
}
