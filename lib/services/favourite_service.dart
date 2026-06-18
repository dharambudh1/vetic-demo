import "dart:developer";

import "package:vetic_assignment/di/service_locator.dart";
import "package:vetic_assignment/services/database_service.dart";

/// Service for managing favorite products
final class FavouriteService {
  /// Database service
  final DatabaseService _databaseService = getIt<DatabaseService>();

  /// Key for storing favorites
  static const String favoritesKey = "favoritesKey";

  /// Get all favorite product IDs
  List<int> getFavoriteIds() {
    List<int> values = <int>[];

    try {
      final dynamic data = _databaseService.readData(favoritesKey) ?? values;

      values = List<int>.from(data);
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return values;
  }

  /// Toggle favorite status of a product
  Future<bool> toggleFavorite(int productId) async {
    bool value = false;

    try {
      final List<int> favorites = getFavoriteIds();

      if (favorites.contains(productId)) {
        favorites.remove(productId);
      } else {
        favorites.add(productId);
      }

      value = await _databaseService.writeData(favoritesKey, favorites);
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return value;
  }

  /// Check if a product is favorite
  bool isFavorite(int productId) {
    bool value = false;

    try {
      final List<int> favorites = getFavoriteIds();

      value = favorites.contains(productId);
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return value;
  }
}
