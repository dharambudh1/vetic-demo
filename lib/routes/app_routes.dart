import "package:get/get.dart";
import "package:vetic_assignment/bindings/favorites/favorites_items_binding.dart";
import "package:vetic_assignment/bindings/product/product_details_binding.dart";
import "package:vetic_assignment/bindings/product/product_listing_binding.dart";
import "package:vetic_assignment/views/favorites/favorites_items_view.dart";
import "package:vetic_assignment/views/product/product_details_view.dart";
import "package:vetic_assignment/views/product/product_listing_view.dart";

/// Application routes configuration
final class AppRoutes {
  /// String constants for route paths
  static const String productListing = "/";
  static const String productDetails = "/product-details";
  static const String favoritesItems = "/favorites-items";

  /// List of application routes
  final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: productListing,
      page: ProductListingView.new,
      binding: ProductListingBinding(),
    ),
    GetPage<dynamic>(
      name: productDetails,
      page: ProductDetailsView.new,
      binding: ProductDetailsBinding(),
    ),
    GetPage<dynamic>(
      name: favoritesItems,
      page: FavoritesItemsView.new,
      binding: FavoritesItemsBinding(),
    ),
  ];
}
