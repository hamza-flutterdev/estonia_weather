
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'appOpen_ads.dart';

class BannerAdController extends GetxController {
  final Map<String, BannerAd> _ads = {};
  final Map<String, RxBool> _adLoaded = {};
  RxBool isAdEnabled = true.obs;
  final AppOpenAdController openAdController=Get.put(AppOpenAdController());


  @override
  void onInit() {
    super.onInit();
    fetchRemoteConfig();
  }

  // Future<void> fetchRemoteConfig() async {
  //   try {
  //     final remoteConfig = FirebaseRemoteConfig.instance;
  //
  //     await remoteConfig.setConfigSettings(RemoteConfigSettings(
  //       fetchTimeout: const Duration(seconds: 10),
  //       minimumFetchInterval: const Duration(minutes: 1),
  //     ));
  //     await remoteConfig.fetchAndActivate();
  //
  //     bool bannerAdsEnabled = remoteConfig.getBool('BannerAd');
  //     isAdEnabled.value = bannerAdsEnabled;
  //
  //     if (bannerAdsEnabled) {
  //       // Preload ads for multiple locations
  //       loadBannerAd('ad1');
  //       loadBannerAd('ad2');
  //       loadBannerAd('ad3');
  //       loadBannerAd('ad4');
  //       loadBannerAd('ad5');
  //       loadBannerAd('ad6');
  //       loadBannerAd('ad7');
  //       loadBannerAd('ad8');
  //       loadBannerAd('ad9');
  //       loadBannerAd('ad10');
  //       loadBannerAd('ad11');
  //       loadBannerAd('ad12');
  //       loadBannerAd('ad13');
  //       loadBannerAd('ad14');
  //       loadBannerAd('ad15');
  //       loadBannerAd('ad16');
  //       loadBannerAd('ad17');
  //       loadBannerAd('ad18');
  //       loadBannerAd('ad19');
  //       loadBannerAd('ad20');
  //       loadBannerAd('ad21');
  //     }
  //   } catch (e) {
  //     print('Error fetching Remote Config: $e');
  //   }
  // }

  Future<void> fetchRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ));

      await remoteConfig.fetchAndActivate();

      // Use platform-specific Remote Config key
      String bannerKey;
      if (Platform.isAndroid) {
        bannerKey = 'BannerAd';
      } else if (Platform.isIOS) {
        bannerKey = 'BannerAd';
      } else {
        throw UnsupportedError('Unsupported platform');
      }

      bool bannerAdsEnabled = remoteConfig.getBool(bannerKey);
      isAdEnabled.value = bannerAdsEnabled;

      if (bannerAdsEnabled) {
        for (int i = 1; i <= 21; i++) {
          loadBannerAd('ad$i');
        }
      }
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }


  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8172082069591999/7509513214';
    } else if (Platform.isIOS) {
      return ' ';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadBannerAd(String key) async{
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }
    final screenWidth = Get.context!.mediaQuerySize.width.toInt();

    final bannerAd = BannerAd(
      adUnitId:bannerAdUnitId,
      size: AdSize(height:55,width:screenWidth),
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key] = true.obs;
          print("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key] = false.obs;
          print("Ad failed to load for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
  }

  @override
  void onClose() {
    for (final ad in _ads.values) {
      ad.dispose();
    }
    super.onClose();
  }

  Widget getBannerAdWidget(String key) {
    if (openAdController.isShowingOpenAd.value) {
      return const SizedBox();
    }
    if (isAdEnabled.value && _ads.containsKey(key) && _adLoaded[key]?.value == true) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color:  Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        height: _ads[key]!.size.height.toDouble(),
        width: double.infinity,
        child: AdWidget(ad: _ads[key]!),
      );
    } else {
      return Shimmer.fromColors(
        baseColor:  Colors.grey[200]!,
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      );
    }
  }
}
