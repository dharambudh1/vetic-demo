import "dart:developer";

import "package:get/get.dart";
import "package:vetic_assignment/data_flow/product_flow.dart";
import "package:vetic_assignment/di/service_locator.dart";
import "package:vetic_assignment/models/product/product_model.dart";
import "package:vetic_assignment/services/connectivity_service.dart";

/// Controller for product details.
final class ProductDetailsController extends GetxController {
  /// Connectivity service instance
  final ConnectivityService connectivityService = getIt<ConnectivityService>();

  /// Product flow instance
  final ProductFlow productFlow = getIt<ProductFlow>();

  /// Rx product model
  final Rx<ProductModel> rxProduct = ProductModel().obs;

  /// Future to fetch data
  late Future<void> future;

  /// Product id
  final RxInt rxProductId = 0.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;

      if (args.containsKey("id")) {
        rxProductId.value = args["id"] as int? ?? 0;
      }
    }

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

    rxProduct.value = products.firstWhere(
      (ProductModel e) {
        /// Find product by id
        return (e.id ?? 0) == (rxProductId.value);
      },
      orElse: () {
        /// Return empty product if not found
        return ProductModel();
      },
    );

    return;
  }

  /// Toggle favorite status of a product
  Future<bool> toggleFavorite(int productId) async {
    final bool result = await productFlow.toggleFavorite(productId);

    rxProduct.refresh();

    return result;
  }

  /// Check if a product is a favorite
  bool isFavorite(int productId) {
    final bool result = productFlow.isFavorite(productId);

    return result;
  }
}
