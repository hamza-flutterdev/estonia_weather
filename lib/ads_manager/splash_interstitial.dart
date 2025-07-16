import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'appOpen_ads.dart';

class SplashInterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  bool isAdReady = false;
  bool showSplashAd = true;

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
    loadInterstitialAd();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ));
      String interstitialKey;
      if (Platform.isAndroid) {
        interstitialKey = 'SplashInterstitialAd';
      } else if (Platform.isIOS) {
        interstitialKey = 'SplashInterstitial';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
      await remoteConfig.fetchAndActivate();
      showSplashAd = remoteConfig.getBool(interstitialKey);
      print("#################### Remote Config: Show Splash Ad = $showSplashAd");
      update();
    } catch (e) {
      print('Error fetching Remote Config: $e');
      showSplashAd = false;
    }
  }

  String get spInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8172082069591999/3661250625';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5405847310750111/3152988310';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:spInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isAdReady = true;
          update();
        },
        onAdFailedToLoad: (error) {
          print("Interstitial Ad failed to load: $error");
          isAdReady = false;
        },
      ),
    );
  }
  void showInterstitialAdForQuiz({VoidCallback? onAdComplete}) {
    if (!showSplashAd) {
      print("### Splash Ad Disabled via Remote Config");
      if (onAdComplete != null) onAdComplete(); // Still proceed
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print("### Interstitial Ad Dismissed");
          Get.find<AppOpenAdController>().setInterstitialAdDismissed();
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();

          if (onAdComplete != null) onAdComplete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("### Interstitial Ad Failed to Show: $error");
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();

          if (onAdComplete != null) onAdComplete();
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("### Interstitial Ad Not Ready.");
      if (onAdComplete != null) onAdComplete(); // Fallback
    }
  }

  Future<void> showInterstitialAd() async{
    if (!showSplashAd) {
      print("### Splash Ad Disabled via Remote Config");
      return;
    }
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print("### Ad Dismissed");
          Get.find<AppOpenAdController>().setInterstitialAdDismissed();
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("### Ad failed to show: $error");
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("### Interstitial Ad not ready.");
    }
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}



