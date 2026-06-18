import "package:flutter/widgets.dart";
import "package:vetic_assignment/widgets/custom_dynamic_height_grid_view.dart";

/// Custom grid view for displaying grid itemsa
class CustomGridView<T> extends StatelessWidget {
  const CustomGridView({
    required this.items,
    required this.itemBuilder,
    this.shrinkWrap = true,
    this.scrollController,
    this.padding = EdgeInsets.zero,
    this.physics = const ScrollPhysics(),
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.mainAxisExtent,
    this.childAspectRatio = 1.0,
    this.scrollDirection = Axis.vertical,
    this.useDynamicHeightGridView = true,
    super.key,
  });

  final List<T> items;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final bool shrinkWrap;
  final ScrollController? scrollController;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double? mainAxisExtent;
  final double childAspectRatio;
  final Axis scrollDirection;
  final bool useDynamicHeightGridView;

  @override
  Widget build(final BuildContext context) {
    return decisionBuilder();
  }

  Widget decisionBuilder() {
    return items.isEmpty
        ? const SizedBox()
        : useDynamicHeightGridView
        ? dynamicHeightGridView()
        : gridViewBuilder();
  }

  Widget dynamicHeightGridView() {
    return CustomDynamicHeightGridView(
      itemCount: items.length,
      builder: (BuildContext context, int index) {
        final T item = items[index];

        return itemBuilder(context, index, item);
      },
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      shrinkWrap: shrinkWrap,
      scrollController: scrollController,
      padding: padding,
      scrollPhysics: physics,
    );
  }

  Widget gridViewBuilder() {
    return GridView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final T item = items[index];

        return itemBuilder(context, index, item);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisExtent: mainAxisExtent,
        childAspectRatio: childAspectRatio,
      ),
      shrinkWrap: shrinkWrap,
      controller: scrollController,
      padding: padding,
      physics: physics,
      scrollDirection: scrollDirection,
    );
  }
}
