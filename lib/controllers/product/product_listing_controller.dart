import "dart:developer";

import "package:flutter/widgets.dart";
import "package:get/get.dart";
import "package:vetic_assignment/data_flow/product_flow.dart";
import "package:vetic_assignment/di/service_locator.dart";
import "package:vetic_assignment/enums/product/product_enums.dart";
import "package:vetic_assignment/models/product/product_model.dart";
import "package:vetic_assignment/routes/app_routes.dart";
import "package:vetic_assignment/services/connectivity_service.dart";
import "package:vetic_assignment/services/navigation_service.dart";

/// Controller for product listing.
final class ProductListingController extends GetxController {
  /// Connectivity service instance
  final ConnectivityService connectivityService = getIt<ConnectivityService>();

  /// Product flow instance
  final ProductFlow productFlow = getIt<ProductFlow>();

  /// Rx list to store products
  final RxList<ProductModel> rxProducts = <ProductModel>[].obs;

  /// Future to fetch data
  late Future<void> future;

  final RxList<ProductFilters> rxProductFilters = ProductFilters.values.obs;
  final Rx<ProductFilters?> rxSelectedFilter = (null as ProductFilters?).obs;

  /// Search text controller
  final TextEditingController searchController = TextEditingController();

  /// Rx for search
  final RxString rxSearch = "".obs;

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

  /// Navigate to favorites items view
  Future<void> navigateToFavouritesItems() async {
    await NavigationService().pushNamed(AppRoutes.favoritesItems);

    /// Reinitialize future to refresh data after returning from product details
    future = init();

    return;
  }

  /// Get final list of products
  RxList<ProductModel> get rxDynamicList {
    List<ProductModel> tempList = List<ProductModel>.from(rxProducts);

    /// Filter products
    switch (rxSelectedFilter.value) {
      case ProductFilters.nameAToZ:
        tempList = sortByName;
        break;

      case ProductFilters.nameZToA:
        tempList = sortByName.reversed.toList().obs;
        break;

      case ProductFilters.priceLowToHigh:
        tempList = sortByPrice;
        break;

      case ProductFilters.priceHighToLow:
        tempList = sortByPrice.reversed.toList().obs;
        break;

      case ProductFilters.ratingLowToHigh:
        tempList = sortByRating;
        break;

      case ProductFilters.ratingHighToLow:
        tempList = sortByRating.reversed.toList().obs;
        break;

      case null:
        break;
    }

    /// Filter products by search query
    tempList = tempList.where((ProductModel e) {
      final String title = (e.title ?? "").trim().toLowerCase();
      final String search = rxSearch.value.trim().toLowerCase();

      /// Check if title contains search query
      return title.contains(search);
    }).toList();

    return tempList.obs;
  }

  /// Sort by name
  RxList<ProductModel> get sortByName {
    final List<ProductModel> tempList = List<ProductModel>.from(rxProducts);

    // ignore: cascade_invocations
    tempList.sort((ProductModel a, ProductModel b) {
      final String nameA = a.title ?? "";
      final String nameB = b.title ?? "";

      /// Compare nameA with nameB
      return nameA.compareTo(nameB);
    });

    return tempList.obs;
  }

  /// Sort by price
  RxList<ProductModel> get sortByPrice {
    final List<ProductModel> tempList = List<ProductModel>.from(rxProducts);

    // ignore: cascade_invocations
    tempList.sort((ProductModel a, ProductModel b) {
      final num priceA = a.price ?? 0.0;
      final num priceB = b.price ?? 0.0;

      /// Compare priceA with priceB
      return priceA.compareTo(priceB);
    });

    return tempList.obs;
  }

  /// Sort by rating
  RxList<ProductModel> get sortByRating {
    final List<ProductModel> tempList = List<ProductModel>.from(rxProducts);

    // ignore: cascade_invocations
    tempList.sort((ProductModel a, ProductModel b) {
      final num ratingA = a.rating?.rate ?? 0.0;
      final num ratingB = b.rating?.rate ?? 0.0;

      /// Compare ratingA with ratingB
      return ratingA.compareTo(ratingB);
    });

    return tempList.obs;
  }

  /// Set filter and pop
  void selectAndPop(ProductFilters? item) {
    /// Select item if not already selected, else null
    rxSelectedFilter.value = (item != rxSelectedFilter.value) ? item : null;

    /// Close modal bottom sheet
    NavigationService().pop();

    return;
  }

  /// Check if filter is applied
  RxBool get isFilterActive {
    return (rxSelectedFilter.value != null).obs;
  }

  /// Check if any favorite is active
  RxBool get isFavouriteActive {
    final List<ProductModel> tempList = List<ProductModel>.from(rxProducts);

    /// Check if any product is a favorite
    return tempList.any((ProductModel e) {
      return isFavorite(e.id ?? 0);
    }).obs;
  }

  /// Check if search is active
  RxBool get isSearchActive {
    return rxSearch.value.isNotEmpty.obs;
  }
}
