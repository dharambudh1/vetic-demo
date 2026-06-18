// ignore_for_file: invalid_use_of_protected_member

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:vetic_assignment/controllers/favorites/favorites_items_controller.dart";
import "package:vetic_assignment/models/product/product_model.dart";
import "package:vetic_assignment/widgets/custom_future_builder.dart";
import "package:vetic_assignment/widgets/custom_grid_view.dart";
import "package:vetic_assignment/widgets/custom_image_viewer.dart";
import "package:vetic_assignment/widgets/custom_text.dart";

/// Favorites items view.
final class FavoritesItemsView extends GetView<FavoritesItemsController> {
  const FavoritesItemsView({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// Remove the shadow from the app bar
        scrolledUnderElevation: 0,
        title: const CustomText(
          data: "Favorites Items",
          style: TextStyle(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: const <Widget>[],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.future = controller.init();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: customFutureBuilder(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom Future builder to show loading and data
  Widget customFutureBuilder(final BuildContext context) {
    return CustomFutureBuilder<void>(
      future: controller.future,
      builder: (BuildContext context, void item) {
        return Obx(() {
          final List<ProductModel> items = controller.rxDynamicList.value;

          if (items.isEmpty) {
            return emptyListWidget(context);
          }

          return customGridView(context);
        });
      },
    );
  }

  Widget emptyListWidget(BuildContext context) {
    // No other way to add favorites so just show this message

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CustomText(
            data: "Nothing in Favorites",
            style: TextStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          OutlinedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color?>(
                Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            onPressed: () async {
              controller.navigateToProductListing();
            },
            child: const CustomText(
              data: "Add some product(s) to favorites",
              style: TextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Custom Grid view to show products
  Widget customGridView(final BuildContext context) {
    return CustomGridView<ProductModel>(
      items: controller.rxDynamicList.value,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      itemBuilder: customGridViewBuilder,
    );
  }

  /// Custom grid view builder to show products
  Widget customGridViewBuilder(
    final BuildContext context,
    final int index,
    final ProductModel item,
  ) {
    return InkWell(
      onTap: () async {
        await controller.navigateToProductDetails(item.id ?? 0);
      },
      child: Card.outlined(
        margin: EdgeInsets.zero,
        child: Stack(
          children: <Widget>[
            Positioned(child: imageWidget(context, item)),
            Positioned(top: 0, right: 0, child: favoriteWidget(context, item)),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: nameWidget(context, item),
            ),
          ],
        ),
      ),
    );
  }

  /// Image widget to show product image
  Widget imageWidget(final BuildContext context, final ProductModel item) {
    return Padding(
      padding: const EdgeInsets.all(56.0),
      child: CustomImageViewer(
        imageUrl: item.image ?? "",
        height: 56 * 2,
        width: 56 * 2,
      ),
    );
  }

  /// Image widget to show product image
  Widget favoriteWidget(final BuildContext context, final ProductModel item) {
    return IconButton(
      isSelected: controller.isFavorite(item.id ?? 0),
      selectedIcon: const Icon(Icons.favorite),
      icon: const Icon(Icons.favorite_border),
      onPressed: () async {
        /// Toggle favorite status of a product
        await controller.toggleFavorite(item.id ?? 0);
      },
    );
  }

  /// Name widget to show product name
  Widget nameWidget(final BuildContext context, final ProductModel item) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodyMedium?.color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
      ),
      child: CustomText(
        data: item.title ?? "",
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
