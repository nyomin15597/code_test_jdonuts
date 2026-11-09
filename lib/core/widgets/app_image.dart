import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String path;
  final BoxFit fit;

  const AppImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
  });

  bool get _isNetworkImage {
    return path.startsWith('https://') ||
        path.startsWith('http://');
  }

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        placeholder: (_, _) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (_, _, _) => const Icon(
          Icons.image_not_supported_outlined,
          size: 50,
        ),
      );
    }

    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (_, _, _) {
        return const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 50,
          ),
        );
      },
    );
  }
}
