import "dart:developer";

import "package:flutter/widgets.dart";
import "package:get/get.dart";

/// Navigation service for handling navigation
final class NavigationService {
  /// Navigator state key
  GlobalKey<NavigatorState> get key {
    return Get.key;
  }

  /// Build context
  BuildContext? get context {
    /// Return current context
    return key.currentContext;
  }

  /// Navigator state
  NavigatorState? get state {
    /// Return current state
    return key.currentState;
  }

  /// Check if can pop
  bool get canPop {
    /// Return whether the current route can be popped
    return state?.canPop() ?? false;
  }

  /// Push named route
  Future<T?> pushNamed<T>(
    final String routeName, {
    final Map<String, dynamic> arguments = const <String, dynamic>{},
  }) async {
    T? value;

    try {
      value = await state?.pushNamed<T>(routeName, arguments: arguments);
    } on Object catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return Future<T?>.value(value);
  }

  /// Pop current route
  void pop<T>({final T? result}) {
    try {
      if (canPop) {
        state?.pop<T>(result);
      } else {}
    } on Object catch (error, stackTrace) {
      log("Exception", error: error, stackTrace: stackTrace);
    } finally {}

    return;
  }
}
