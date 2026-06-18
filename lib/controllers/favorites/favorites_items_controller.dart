import "dart:developer";

import "package:get/get.dart";
import "package:vetic_assignment/data_flow/product_flow.dart";
import "package:vetic_assignment/di/service_locator.dart";
import "package:vetic_assignment/models/product/product_model.dart";
import "package:vetic_assignment/routes/app_routes.dart";
import "package:vetic_assignment/services/connectivity_service.dart";
import "package:vetic_assignment/services/navigation_service.dart";

/// Controller for favorites items.
final class FavoritesItemsController extends GetxController {
  /// Connectivity service instance
  final ConnectivityService connectivityService = getIt<ConnectivityService>();

  /// Product flow instance
  final ProductFlow productFlow = getIt<ProductFlow>();

  /// Rx list to store products
  final RxList<ProductModel> rxProducts = <ProductModel>[].obs;

  /// Future to fetch data
  late Future<void> future;

  @override
  void onInit() {
    super.onInit();

    /// Initialize product data using product flow
    future = init();

    /// Listen to connectivity changes and reinitialize future if connected
    connectivityService.isConnected.listenAndPump(
      (bool value) {
        // If connected then reinitialize future to refresh data
        if (value) {
          /// Reinitialize future to refresh data
          future = init();
        }
      },
      onError: (Object error) {
        log("Error in connectivity: $error");
      },
    );
  }

  /// Initialize product data using product flow
  Future<void> init() async {
    final List<ProductModel> products = await productFlow.init();

    rxProducts
      ..clear()
      ..addAll(products);

    return;
  }

  /// Toggle favorite status of a product
  Future<bool> toggleFavorite(int productId) async {
    final bool result = await productFlow.toggleFavorite(productId);

    rxProducts.refresh();

    return result;
  }

  /// Check if a product is a favorite
  bool isFavorite(int productId) {
    final bool result = productFlow.isFavorite(productId);

    return result;
  }

  /// Navigate to product details view
  Future<void> navigateToProductDetails(int id) async {
    await NavigationService().pushNamed(
      AppRoutes.productDetails,

      /// Pass arguments as map
      arguments: <String, dynamic>{"id": id},
    );

    /// Reinitialize future to refresh data after returning from product details
    future = init();

    return;
  }

  /// Navigate to product listing view
  void navigateToProductListing() {
    NavigationService().pop();

    return;
  }

  /// Get final list of products
  RxList<ProductModel> get rxDynamicList {
    List<ProductModel> tempList = List<ProductModel>.from(rxProducts);

    /// Filter products which are favorited by the user
    tempList = tempList.where((ProductModel e) {
      // Directly use isFavorite() for a cleaner look

      return isFavorite(e.id ?? 0);
    }).toList();

    return tempList.obs;
  }
}
