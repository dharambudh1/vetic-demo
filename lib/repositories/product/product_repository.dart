// ignore_for_file: lines_longer_than_80_chars

import "dart:developer";

import "package:vetic_assignment/constants/method_constants.dart";
import "package:vetic_assignment/di/service_locator.dart";
import "package:vetic_assignment/models/product/product_model.dart";
import "package:vetic_assignment/services/api_service.dart";
import "package:vetic_assignment/utils/api_endpoints.dart";

/// Product repository for handling product related api requests
final class ProductRepository {
  /// API service
  final APIService _apiService = getIt<APIService>();

  /// API endpoints
  final APIEndpoints _apiEndpoints = APIEndpoints();

  /// HTTP method constants
  final MethodConstants _methodConstants = MethodConstants();

  /// Get all products from server
  Future<List<ProductModel>> getProducts() async {
    final List<ProductModel> values = <ProductModel>[];

    try {
      /// Process request to server
      final (bool, dynamic) result = await _apiService.process(
        url: _apiEndpoints.products(),
        method: _methodConstants.get,
      );

      /// Check if request is successful and response is not null and response is of type List<dynamic>
      if (result.$1 && result.$2 != null && result.$2 is List<dynamic>) {
        /// Iterate over response and convert each value to ProductModel
        for (final dynamic value in result.$2 as List<dynamic>) {
          /// Add product to values list
          values.add(ProductModel.fromJson(value as Map<String, dynamic>));
        }
      }
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return values;
  }

  /// Get product by id from server
  Future<ProductModel> getProduct(int id) async {
    ProductModel value = ProductModel();

    try {
      /// Process request to server
      final (bool, dynamic) result = await _apiService.process(
        url: _apiEndpoints.productDetails(id),
        method: _methodConstants.get,
      );

      /// Check if request is successful and response is not null and response is of type Map<String, dynamic>
      if (result.$1 && result.$2 != null && result.$2 is Map<String, dynamic>) {
        /// Convert response to ProductModel
        value = ProductModel.fromJson(result.$2 as Map<String, dynamic>);
      }
    } on Object catch (error, stackTrace) {
      log("Error", error: error, stackTrace: stackTrace);
    }

    return value;
  }
}
