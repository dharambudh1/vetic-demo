import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:vetic_assignment/controllers/product/product_details_controller.dart";
import "package:vetic_assignment/models/product/product_model.dart";
import "package:vetic_assignment/widgets/animated_read_more.dart";
import "package:vetic_assignment/widgets/custom_future_builder.dart";
import "package:vetic_assignment/widgets/custom_image_viewer.dart";
import "package:vetic_assignment/widgets/custom_text.dart";

/// Product details view.
final class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// Remove the shadow from the app bar
        scrolledUnderElevation: 0,
        title: const CustomText(
          data: "Product Details",
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
          return mainWidget(context);
        });
      },
    );
  }

  /// Main widget to show product details
  Widget mainWidget(final BuildContext context) {
    final ProductModel item = controller.rxProduct.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        favoriteWidget(context, item),
        const SizedBox(height: 8.0),
        imageWidget(context, item),
        const SizedBox(height: 8.0),
        nameWidget(context, item),
        const SizedBox(height: 8.0),
        descriptionWidget(context, item),
        const SizedBox(height: 8.0),
        categoryWidget(context, item),
        const SizedBox(height: 8.0),
        priceWidget(context, item),
        const SizedBox(height: 8.0),
        rateAndCountWidget(context, item),
      ],
    );
  }

  /// Image widget to show product image
  Widget imageWidget(final BuildContext context, final ProductModel item) {
    return Center(
      child: CustomImageViewer(
        imageUrl: item.image ?? "",
        height: 56 * 4,
        width: 56 * 4,
      ),
    );
  }

  /// Name widget to show product name
  Widget nameWidget(final BuildContext context, final ProductModel item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CustomText(
          data: "Name:",
          style: TextStyle(fontSize: 10),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        CustomText(
          data: item.title ?? "",
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Description widget to show product description
  Widget descriptionWidget(
    final BuildContext context,
    final ProductModel item,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CustomText(
          data: "Description:",
          style: TextStyle(fontSize: 10),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        AnimatedReadMore(
          data: item.description ?? "",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  /// Category widget to show product category
  Widget categoryWidget(final BuildContext context, final ProductModel item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CustomText(
          data: "Category:",
          style: TextStyle(fontSize: 10),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        CustomText(
          data: item.category ?? "",
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Price widget to show product price
  Widget priceWidget(final BuildContext context, final ProductModel item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CustomText(
          data: "Price:",
          style: TextStyle(fontSize: 10),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        CustomText(
          data: "${item.price ?? 0}",
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Rate and count widget to show product rating and count
  Widget rateAndCountWidget(
    final BuildContext context,
    final ProductModel item,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CustomText(
          data: "Rating:",
          style: TextStyle(fontSize: 10),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        CustomText(
          data: "${item.rating?.rate ?? 0} (${item.rating?.count ?? 0})",
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Favorite widget to show favorite icon
  Widget favoriteWidget(final BuildContext context, final ProductModel item) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        isSelected: controller.isFavorite(item.id ?? 0),
        selectedIcon: const Icon(Icons.favorite),
        icon: const Icon(Icons.favorite_border),
        onPressed: () async {
          /// Toggle favorite status of a product
          await controller.toggleFavorite(item.id ?? 0);
        },
      ),
    );
  }
}
