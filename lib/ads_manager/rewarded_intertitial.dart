import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'appOpen_ads.dart';

class RewardAdController extends GetxController {
  RewardedInterstitialAd? _rewardedInterstitialAd;
  final String adUnitId = 'ca-app-pub-5405847310750111/3097008374';

  var isAdLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAd();
  }

  void loadAd() {
    print('Loading Rewarded Interstitial Ad...');
    RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          print('Ad loaded successfully.');
          _rewardedInterstitialAd = ad;
          isAdLoaded.value = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load ad: ${error.message}');
          _rewardedInterstitialAd = null;
          isAdLoaded.value = false;
        },
      ),
    );
  }

  void showAd({VoidCallback? onAdComplete}) {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (Ad ad) {
          ad.dispose();
          Get.find<AppOpenAdController>().setInterstitialAdDismissed();
          loadAd();
          if (onAdComplete != null) {
            onAdComplete();
          }
        },
        onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
          print('Ad failed to show: ${error.message}');
          ad.dispose();
          Get.find<AppOpenAdController>().setInterstitialAdDismissed();
          loadAd();
        },
        onAdShowedFullScreenContent: (Ad ad) {
          print('Ad is showing...');
        },
      );

      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
        },
      );

      _rewardedInterstitialAd = null;
      isAdLoaded.value = false;
    } else {
      Get.snackbar(
        "Ad Status",
        "Ad not ready yet. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      loadAd();
    }
  }

  @override
  void onClose() {
    _rewardedInterstitialAd?.dispose();
    super.onClose();
  }
}
