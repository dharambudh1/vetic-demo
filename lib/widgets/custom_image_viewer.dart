import "dart:developer";

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

/// Custom image viewer for displaying images
class CustomImageViewer extends StatelessWidget {
  const CustomImageViewer({
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    super.key,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      progressIndicatorBuilder:
          (BuildContext context, String url, DownloadProgress progress) {
            return Center(
              child: CircularProgressIndicator(value: progress.progress),
            );
          },
      errorWidget: (BuildContext context, String url, Object error) {
        log("Exception", error: error);

        return const Center(child: Icon(Icons.error));
      },
      errorListener: (Object error) {
        log("Exception", error: error);
      },
      useOldImageOnUrlChange: true,
    );
  }
}
