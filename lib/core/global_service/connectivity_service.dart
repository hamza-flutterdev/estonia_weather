import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get instance => Get.find<ConnectivityService>();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final _isConnected = false.obs;
  final _isCheckingInternet = false.obs;
  final _lastConnectivityResult = ConnectivityResult.none.obs;

  final _internetStatusController = StreamController<bool>.broadcast();
  final _connectivityController =
      StreamController<ConnectivityResult>.broadcast();

  bool get isConnected => _isConnected.value;

  bool get isCheckingInternet => _isCheckingInternet.value;

  ConnectivityResult get lastConnectivityResult =>
      _lastConnectivityResult.value;

  Stream<bool> get internetStatusStream => _internetStatusController.stream;

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityController.stream;

  Timer? _internetCheckTimer;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeConnectivity();
    _startListeningToConnectivityChanges();
    _startPeriodicInternetCheck();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    _internetCheckTimer?.cancel();
    _internetStatusController.close();
    _connectivityController.close();
    super.onClose();
  }

  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _lastConnectivityResult.value = result.first;
      _connectivityController.add(result.first);

      await _checkRealInternetConnectivity();
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
        _lastConnectivityResult.value = result;
        _connectivityController.add(result);

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

  void _startPeriodicInternetCheck() {
    _internetCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_lastConnectivityResult.value != ConnectivityResult.none) {
        _checkRealInternetConnectivity();
      }
    });
  }

  Future<void> _checkRealInternetConnectivity() async {
    if (_isCheckingInternet.value) return;

    _isCheckingInternet.value = true;

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
    } finally {
      _isCheckingInternet.value = false;
    }
  }

  Future<bool> checkInternetNow() async {
    if (_lastConnectivityResult.value == ConnectivityResult.none) {
      return false;
    }

    await _checkRealInternetConnectivity();
    return _isConnected.value;
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
              const SizedBox(height: 16),
              // Real-time connectivity status
              Obx(
                () => Row(
                  children: [
                    Icon(
                      _isConnected.value ? Icons.wifi : Icons.wifi_off,
                      color: _isConnected.value ? kGreen : kRed,
                    ),
                    const SizedBox(width: 8),
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
    // Force a fresh check with timeout
    bool hasRealInternet = false;

    try {
      hasRealInternet = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5))
          .then(
            (result) => result.isNotEmpty && result[0].rawAddress.isNotEmpty,
          )
          .catchError((e) {
            debugPrint('[ConnectivityService] Timeout or error: $e');
            return false;
          });
    } catch (e) {
      debugPrint('[ConnectivityService] Error in lookup: $e');
      hasRealInternet = false;
    }

    if (!hasRealInternet) {
      await showNoInternetDialog(context, onRetry: onRetry);
      return false;
    }

    return true;
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
    _internetSubscription = connectivityService.internetStatusStream.listen((
      bool hasInternet,
    ) {
      onInternetStatusChanged(hasInternet);
    });
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
    // Called when internet becomes available
    debugPrint('[$runtimeType] Internet connected - refreshing data');
  }

  void onInternetDisconnected() {
    // Called when internet becomes unavailable
    debugPrint('[$runtimeType] Internet disconnected');
  }

  // Helper method to check internet before performing actions
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
}
