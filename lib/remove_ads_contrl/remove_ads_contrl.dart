import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoveAds extends GetxController {
  var isSubscribedGet = false.obs;
  @override
  void onInit() {
    super.onInit();
    checkSubscriptionStatus();
  }

  Future<void> checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isSubscribed = prefs.getBool('SubscribeEstonia') ?? false;
    isSubscribedGet.value = isSubscribed;
  }
}
