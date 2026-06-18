// ignore_for_file: avoid_annotating_with_dynamic

import "dart:developer";

import "package:get_storage/get_storage.dart";

/// Database service to handle data operations
final class DatabaseService {
  /// Storage instance to store data
  final GetStorage _storage = GetStorage();

  /// Initialize GetStorage
  Future<bool> initGetStorage() async {
    bool status = false;

    try {
      status = await GetStorage.init();
      log("GetStorage initialized $status");
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return Future<bool>.value(status);
  }

  /// Write data to database
  Future<bool> writeData(String key, dynamic value) async {
    bool status = false;

    try {
      await _storage.write(key, value);
      status = true;
      log("Data written on $key");
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return Future<bool>.value(status);
  }

  /// Read data from database
  dynamic readData(String key) {
    dynamic value;

    try {
      value = _storage.read<dynamic>(key) ?? value;
      log("Data read from $key");
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return value;
  }

  /// Remove data from database
  Future<bool> removeData(String key) async {
    bool status = false;

    try {
      await _storage.remove(key);
      status = true;
      log("Data removed from $key");
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return Future<bool>.value(status);
  }

  /// Remove all data from database
  Future<bool> removeAllData() async {
    bool status = false;

    try {
      await _storage.erase();
      status = true;
      log("All data removed");
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return Future<bool>.value(status);
  }
}
