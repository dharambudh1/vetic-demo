// ignore_for_file: invalid_use_of_protected_member

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:vetic_assignment/controllers/product/product_listing_controller.dart";
import "package:vetic_assignment/enums/product/product_enums.dart";
import "package:vetic_assignment/models/product/product_model.dart";
import "package:vetic_assignment/widgets/custom_future_builder.dart";
import "package:vetic_assignment/widgets/custom_grid_view.dart";
import "package:vetic_assignment/widgets/custom_image_viewer.dart";
import "package:vetic_assignment/widgets/custom_text.dart";
import "package:vetic_assignment/widgets/custom_text_form_field.dart";

/// Product listing view.
final class ProductListingView extends GetView<ProductListingController> {
  const ProductListingView({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// Remove the shadow from the app bar
        scrolledUnderElevation: 0,
        title: const CustomText(
          data: "Products Items",
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
            const SizedBox(height: 0.0),
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
            const SizedBox(height: 8.0),
            bottomRow(context),
            const SizedBox(height: 0.0),
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
            return emptyListWidget();
          }

          return customGridView(context);
        });
      },
    );
  }

  Widget emptyListWidget() {
    final List<ProductModel> items = controller.rxDynamicList.value;

    final bool isFilterActive = controller.isFilterActive.value;
    final bool isSearchActive = controller.isSearchActive.value;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (items.isEmpty && !isFilterActive && !isSearchActive) ...<Widget>[
            const CustomText(
              data: "No Data Available",
              style: TextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            OutlinedButton(
              onPressed: () async {
                controller.future = controller.init();
              },
              child: const CustomText(
                data: "Refresh",
                style: TextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else ...<Widget>[
            const CustomText(
              data: "No product found for selected filter or search",
              style: TextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            OutlinedButton(
              onPressed: () async {
                controller.rxSelectedFilter.value = null;
                controller.searchController.text = "";
                controller.rxSearch.value = "";
              },
              child: const CustomText(
                data: "Clear",
                style: TextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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

  /// Favorite widget to show favorite icon
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

  /// Bottom row to show filter, search and favorite icon
  Widget bottomRow(final BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(width: 8.0),
        Obx(() {
          return IconButton.outlined(
            onPressed: () async {
              await showBottomSheet(context);
            },
            icon: Icon(
              controller.isFilterActive.value
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
              size: 16,
            ),
          );
        }),
        const SizedBox(width: 8.0),
        Expanded(
          child: CustomTextFormField(
            controller: controller.searchController,
            onChanged: controller.rxSearch.call,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            validator: (String? p0) {
              return null;
            },
            labelText: "Search",
            hintText: "Search by name",
          ),
        ),
        const SizedBox(width: 8.0),
        Obx(() {
          return IconButton.outlined(
            onPressed: controller.navigateToFavouritesItems,
            icon: Icon(
              controller.isFavouriteActive.value
                  ? Icons.favorite
                  : Icons.favorite_outline,
              size: 16,
            ),
          );
        }),
        const SizedBox(width: 8.0),
      ],
    );
  }

  /// Bottom sheet to show filter
  Future<void> showBottomSheet(final BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...List<Widget>.generate(controller.rxProductFilters.length, (
              int index,
            ) {
              final ProductFilters item = controller.rxProductFilters[index];

              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                selected: controller.rxSelectedFilter.value == item,
                leading: controller.rxSelectedFilter.value == item
                    ? const Icon(Icons.done)
                    : null,
                title: CustomText(
                  data: item.title,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () async {
                  /// Select the filter and pop the bottom sheet
                  controller.selectAndPop(item);
                },
              );
            }),
            const SizedBox(height: kBottomNavigationBarHeight),
          ],
        );
      },
    );
  }
}
