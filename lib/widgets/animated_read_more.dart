import "package:animated_read_more_text/animated_read_more_text.dart";
import "package:flutter/widgets.dart";
import "package:vetic_assignment/widgets/custom_text.dart";

/// Animated read more widget for displaying read more text
class AnimatedReadMore extends StatelessWidget {
  const AnimatedReadMore({
    required this.data,
    this.maxLines = 2,
    this.style,
    super.key,
  });

  final String data;
  final int maxLines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    /// If data is empty, return custom text with no content
    return data.isEmpty
        ? CustomText(data: data, style: style, maxLines: maxLines)
        : AnimatedReadMoreText(data, textStyle: style, maxLines: maxLines);
  }
}
