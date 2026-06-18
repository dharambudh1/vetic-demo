import "dart:async";
import "dart:developer";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:get/get.dart";

/// A service class to handle connectivity checks.
final class ConnectivityService {
  /// Stream subscription for connectivity changes
  StreamSubscription<List<ConnectivityResult>>? subscription;

  /// RxBool to check connectivity
  final RxBool isConnected = false.obs;

  /// Start listening to connectivity changes
  Future<void> startListening() async {
    subscription = Connectivity().onConnectivityChanged.listen((
      final List<ConnectivityResult> result,
    ) {
      /// Check if device is connected to internet
      isConnected.value = !result.contains(ConnectivityResult.none);

      /// Log connectivity changes
      log("Connectivity from onConnectivityChanged: ${isConnected.value}");
    });
  }

  /// Stop listening to connectivity changes
  void stopListening() {
    unawaited(subscription?.cancel());

    return;
  }
}
