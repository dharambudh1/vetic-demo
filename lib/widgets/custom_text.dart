import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/widgets.dart";

/// Custom text for displaying text
class CustomText extends StatelessWidget {
  const CustomText({
    required this.data,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.autoSize = true,
    super.key,
  });

  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool autoSize;

  @override
  Widget build(final BuildContext context) {
    return textWidget();
  }

  Widget textWidget() {
    return autoSize
        ? AutoSizeText(
            data,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          )
        : Text(
            data,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          );
  }
}
