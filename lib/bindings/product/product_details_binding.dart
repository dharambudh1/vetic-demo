import "package:get/get.dart";
import "package:vetic_assignment/controllers/product/product_details_controller.dart";

/// Binding for product details
final class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailsController>(ProductDetailsController.new);
  }
}
