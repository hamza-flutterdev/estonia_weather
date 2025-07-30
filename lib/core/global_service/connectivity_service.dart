import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:estonia_weather/core/common/app_exceptions.dart';
import 'package:estonia_weather/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get instance => Get.find<ConnectivityService>();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final _isConnected = false.obs;
  final _internetStatusController = StreamController<bool>.broadcast();

  bool get isConnected => _isConnected.value;
  Stream<bool> get internetStatusStream => _internetStatusController.stream;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeConnectivity();
    _startListeningToConnectivityChanges();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    _internetStatusController.close();
    super.onClose();
  }

  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final hasConnection = result.first != ConnectivityResult.none;

      if (hasConnection) {
        await _checkRealInternetConnectivity();
      } else {
        _isConnected.value = false;
        _internetStatusController.add(false);
      }
    } catch (e) {
      debugPrint('[ConnectivityService] Error initializing connectivity: $e');
      _isConnected.value = false;
      _internetStatusController.add(false);
    }
  }

  void _startListeningToConnectivityChanges() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        final result = results.first;
        debugPrint('[ConnectivityService] Connectivity changed: $result');

        if (result == ConnectivityResult.none) {
          _isConnected.value = false;
          _internetStatusController.add(false);
        } else {
          await _checkRealInternetConnectivity();
        }
      },
      onError: (error) {
        debugPrint('[ConnectivityService] Connectivity stream error: $error');
        _isConnected.value = false;
        _internetStatusController.add(false);
      },
    );
  }

  Future<void> _checkRealInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (_isConnected.value != hasInternet) {
        _isConnected.value = hasInternet;
        _internetStatusController.add(hasInternet);
        debugPrint(
          '[ConnectivityService] Internet status changed: $hasInternet',
        );
      }
    } catch (e) {
      debugPrint('[ConnectivityService] Internet check failed: $e');
      if (_isConnected.value) {
        _isConnected.value = false;
        _internetStatusController.add(false);
      }
    }
  }

  Future<bool> checkInternetNow() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.first == ConnectivityResult.none) {
        return false;
      }

      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      _isConnected.value = hasInternet;
      _internetStatusController.add(hasInternet);
      return hasInternet;
    } catch (e) {
      debugPrint('[ConnectivityService] checkInternetNow failed: $e');
      _isConnected.value = false;
      _internetStatusController.add(false);
      return false;
    }
  }

  Future<void> showNoInternetDialog(
    BuildContext context, {
    required Future<void> Function() onRetry,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please check your internet connection and try again.",
              ),
              const SizedBox(height: kBodyHp),
              Obx(
                () => Row(
                  children: [
                    Icon(
                      _isConnected.value ? Icons.wifi : Icons.wifi_off,
                      color: _isConnected.value ? kGreen : kRed,
                    ),
                    const SizedBox(width: kElementWidthGap),
                    Text(
                      _isConnected.value ? "Connected" : "Disconnected",
                      style: TextStyle(
                        color: _isConnected.value ? kGreen : kRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            Obx(
              () => ElevatedButton(
                onPressed:
                    _isConnected.value
                        ? () async {
                          Navigator.of(context).pop();
                          await onRetry();
                        }
                        : null,
                child: const Text("Retry"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkInternetWithDialog(
    BuildContext context, {
    required Future<void> Function() onRetry,
  }) async {
    try {
      final hasInternet = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5))
          .then(
            (result) => result.isNotEmpty && result[0].rawAddress.isNotEmpty,
          )
          .catchError((e) => false);

      if (!hasInternet) {
        await showNoInternetDialog(context, onRetry: onRetry);
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('[ConnectivityService] checkInternetWithDialog failed: $e');
      await showNoInternetDialog(context, onRetry: onRetry);
      return false;
    }
  }
}

mixin ConnectivityMixin on GetxController {
  ConnectivityService get connectivityService => ConnectivityService.instance;
  late StreamSubscription<bool> _internetSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToInternetChanges();
  }

  @override
  void onClose() {
    _internetSubscription.cancel();
    super.onClose();
  }

  void _listenToInternetChanges() {
    _internetSubscription = connectivityService.internetStatusStream.listen(
      (bool hasInternet) => onInternetStatusChanged(hasInternet),
    );
  }

  void onInternetStatusChanged(bool hasInternet) {
    debugPrint('[$runtimeType] Internet status changed: $hasInternet');
    if (hasInternet) {
      onInternetConnected();
    } else {
      onInternetDisconnected();
    }
  }

  void onInternetConnected() {
    debugPrint('[$runtimeType] Internet connected - refreshing data');
  }

  void onInternetDisconnected() {
    debugPrint('[$runtimeType] Internet disconnected');
  }

  Future<bool> ensureInternetConnection({
    required Future<void> Function() action,
    BuildContext? context,
  }) async {
    if (!connectivityService.isConnected) {
      if (context != null) {
        await connectivityService.showNoInternetDialog(
          context,
          onRetry: action,
        );
      }
      return false;
    }

    try {
      await action();
      return true;
    } catch (e) {
      debugPrint('[$runtimeType] Action failed: $e');
      return false;
    }
  }

  Future<void> initWithConnectivityCheck({
    required BuildContext context,
    required Future<void> Function() onConnected,
  }) async {
    final hasInternet = await connectivityService.checkInternetWithDialog(
      context,
      onRetry:
          () => initWithConnectivityCheck(
            context: context,
            onConnected: onConnected,
          ),
    );

    if (hasInternet) {
      await onConnected();
    } else {
      debugPrint(noInternet);
    }
  }

}
