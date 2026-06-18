import "dart:developer";

import "package:flutter/material.dart";
import "package:future_builder_ex/future_builder_ex.dart";

/// Custom future builder for handling future
class CustomFutureBuilder<T> extends StatelessWidget {
  const CustomFutureBuilder({
    required this.future,
    required this.builder,
    this.initialData,
    super.key,
  });

  final T? initialData;
  final Future<T> future;
  final Widget Function(BuildContext, T?) builder;

  @override
  Widget build(final BuildContext context) {
    return FutureBuilderEx<T>(
      initialData: initialData,
      future: future,
      builder: builder,
      waitingBuilder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (BuildContext context, Object error) {
        log("Exception", error: error);

        return const Center(child: Icon(Icons.error));
      },
    );
  }
}
