import "package:get/get.dart";
import "package:vetic_assignment/di/service_locator.dart";
import "package:vetic_assignment/models/product/product_model.dart";
import "package:vetic_assignment/repositories/product/product_repository.dart";
import "package:vetic_assignment/services/favourite_service.dart";

final class ProductFlow {
  /// Product repository
  final ProductRepository repository = ProductRepository();

  /// Favourite service
  final FavouriteService favouriteService = getIt<FavouriteService>();

  /// Rx list to store products
  final RxList<ProductModel> rxProducts = <ProductModel>[].obs;

  /// Initialize product flow
  Future<List<ProductModel>> init() async {
    /// Check if products are already loaded
    if (rxProducts.isNotEmpty) {
      /// Return cached products
      return rxProducts;
    }

    final List<ProductModel> products = await repository.getProducts();

    rxProducts
      ..clear()
      ..addAll(products);

    return rxProducts;
  }

  /// Toggle favorite status of a product
  Future<bool> toggleFavorite(int productId) async {
    final bool result = await favouriteService.toggleFavorite(productId);

    rxProducts.refresh();

    return result;
  }

  /// Check if a product is a favorite
  bool isFavorite(int productId) {
    final bool result = favouriteService.isFavorite(productId);

    return result;
  }
}
