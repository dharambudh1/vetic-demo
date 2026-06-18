import "package:get/get.dart";
import "package:vetic_assignment/controllers/product/product_listing_controller.dart";

/// Binding for product listing.
final class ProductListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListingController>(ProductListingController.new);
  }
}
