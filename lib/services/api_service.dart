import "dart:async";
import "dart:developer";
import "dart:io";

import "package:get/get.dart";
import "package:retry/retry.dart";
import "package:vetic_assignment/constants/method_constants.dart";
import "package:vetic_assignment/di/service_locator.dart";
import "package:vetic_assignment/services/database_service.dart";
import "package:vetic_assignment/utils/api_endpoints.dart";

/// API service for handling api requests
final class APIService {
  /// GetConnect instance
  final GetConnect _connect = GetConnect();

  /// API endpoints
  final APIEndpoints _apiConstants = APIEndpoints();

  /// HTTP method constants
  final MethodConstants _methodConstants = MethodConstants();

  /// Database service
  final DatabaseService _databaseService = getIt<DatabaseService>();

  /// Check if server is connected
  Future<bool> checkPing() async {
    bool value = false;

    try {
      /// Send request to server with retry logic
      final Response<dynamic> result = await retry<Response<dynamic>>(
        () {
          /// Send HEAD request to server
          return _connect.request(
            _apiConstants.pingServer(),

            /// HEAD request is used to check if server is connected or not.
            _methodConstants.head,
          );
        },

        /// Retry if error is socket exception or timeout exception
        retryIf: (Exception error) {
          return error is SocketException || error is TimeoutException;
        },
      );

      value = result.isOk;
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return value;
  }

  /// Send request to server
  Future<(bool, dynamic)> sendRequest({
    required String url,
    required String method,
  }) async {
    (bool, dynamic) value = (false, null);

    try {
      /// Send request to server with retry logic
      final Response<dynamic> result = await retry<Response<dynamic>>(
        () {
          return _connect.request(url, method);
        },

        /// Retry if error is socket exception or timeout exception
        retryIf: (Exception error) {
          return error is SocketException || error is TimeoutException;
        },
      );

      value = (result.isOk, result.body);
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return value;
  }

  /// Process request to server
  Future<(bool, dynamic)> process({
    required String url,
    required String method,
  }) async {
    (bool, dynamic) value = (false, null);

    try {
      /// Check if server is connected
      final bool connected = await checkPing();

      if (connected) {
        /// Send request to server
        value = await sendRequest(url: url, method: method);

        /// Write data to database if request is successful
        if (value.$1) {
          await _databaseService.writeData(url, value.$2);
        }
      } else {
        /// Return cached data if server is not connected
        value = (true, _databaseService.readData(url));
      }
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return value;
  }
}
