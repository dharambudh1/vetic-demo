import "package:get/get.dart";
import "package:vetic_assignment/controllers/favorites/favorites_items_controller.dart";

/// Binding for favorites items.
final class FavoritesItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesItemsController>(FavoritesItemsController.new);
  }
}
