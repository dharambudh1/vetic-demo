import "package:flutter/widgets.dart";

/// Custom dynamic height grid view for displaying grid items
class CustomDynamicHeightGridView extends StatelessWidget {
  const CustomDynamicHeightGridView({
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    this.shrinkWrap = true,
    this.padding = EdgeInsets.zero,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.scrollController,
    this.scrollPhysics,
    super.key,
  });

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final bool shrinkWrap;
  final EdgeInsets padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: columnLength,
      padding: padding,
      controller: scrollController,
      physics: scrollPhysics,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      itemBuilder: itemBuilder,
    );
  }

  Widget itemBuilder(final BuildContext context, final int index) {
    return GridRow(
      columnIndex: index,
      builder: builder,
      itemCount: itemCount,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      rowCrossAxisAlignment: rowCrossAxisAlignment,
    );
  }

  int get columnLength {
    final int value = (itemCount % crossAxisCount == 0)
        ? (itemCount ~/ crossAxisCount)
        : (itemCount ~/ crossAxisCount) + 1;
    return value;
  }
}

class SliverDynamicHeightGridView extends StatelessWidget {
  const SliverDynamicHeightGridView({
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    this.shrinkWrap = true,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.scrollController,
    this.scrollPhysics,
    super.key,
  });

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final bool shrinkWrap;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(final BuildContext context) {
    return SliverList(delegate: delegate);
  }

  SliverChildBuilderDelegate get delegate {
    return SliverChildBuilderDelegate(itemBuilder, childCount: columnLength);
  }

  Widget itemBuilder(final BuildContext context, final int index) {
    return GridRow(
      columnIndex: index,
      builder: builder,
      itemCount: itemCount,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      rowCrossAxisAlignment: rowCrossAxisAlignment,
    );
  }

  int get columnLength {
    final int value = (itemCount % crossAxisCount == 0)
        ? (itemCount ~/ crossAxisCount)
        : (itemCount ~/ crossAxisCount) + 1;
    return value;
  }
}

class GridRow extends StatelessWidget {
  const GridRow({
    required this.columnIndex,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.rowCrossAxisAlignment,
    super.key,
  });

  final int columnIndex;
  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: (columnIndex == 0) ? 0 : mainAxisSpacing),
      child: Row(
        crossAxisAlignment: rowCrossAxisAlignment,
        children: List<Widget>.generate((crossAxisCount * 2) - 1, (
          int rowIndex,
        ) {
          final int rowNum = rowIndex + 1;

          if (rowNum.isEven) {
            return SizedBox(width: crossAxisSpacing);
          } else {}

          final int rowItemIndex = ((rowNum + 1) ~/ 2) - 1;

          final int itemIndex = (columnIndex * crossAxisCount) + rowItemIndex;

          if (itemIndex > itemCount - 1) {
            return const Expanded(child: SizedBox());
          } else {}

          return Expanded(child: builder(context, itemIndex));
        }),
      ),
    );
  }
}
