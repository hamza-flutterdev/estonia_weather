import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'appOpen_ads.dart';

class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  bool isAdReady = false;
  int screenVisitCount = 0;
  int adTriggerCount = 3;

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

      await remoteConfig.fetchAndActivate();

      String interstitialKey;
      if (Platform.isAndroid) {
        interstitialKey = 'InterstitialAd';
      } else if (Platform.isIOS) {
        interstitialKey = 'InterstitialAd';
      } else {
        throw UnsupportedError('Unsupported platform');
      }

      if (remoteConfig.getValue(interstitialKey).source != ValueSource.valueStatic) {
        adTriggerCount = remoteConfig.getInt(interstitialKey);
        print("### Remote Config: Ad Trigger Count = $adTriggerCount");
      } else {
        print("### Remote Config: Using default value.");
      }
      update();
    } catch (e) {
      print('Error fetching Remote Config: $e');
      adTriggerCount = 3;
    }
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return
        //'ca-app-pub-3940256099942544/1033173712';
        'ca-app-pub-8172082069591999/2985343646';
    } else if (Platform.isIOS) {
      return ' ';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:interstitialAdUnitId,
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

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print("### Ad Dismissed, resetting visit count.");
          screenVisitCount = 0;
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("### Ad failed to show: $error");
          screenVisitCount = 0; // ✅ Reset on failure too
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
      );

      print("### Showing Interstitial Ad.");
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("### Interstitial Ad not ready.");
    }
  }

  void checkAndShowAd() {
    screenVisitCount++;
    print("############## Screen Visit Count: $screenVisitCount");

    if (screenVisitCount >= adTriggerCount) {
      print("### OK");
      if (isAdReady) {
        showInterstitialAd();
      } else {
        print("### Interstitial Ad not ready yet.");
        screenVisitCount = 0;
      }
    }
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}