import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Displays product images from disk when the device is offline.
class CachedProductImage extends StatelessWidget {
  const CachedProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.errorIconSize = 40,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double errorIconSize;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      return _errorPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      // The package checks its disk cache before attempting the network.
      // This keeps the Home images available alongside the Hive product cache.
      placeholder: (_, __) => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (_, __, ___) => _errorPlaceholder(),
    );
  }

  Widget _errorPlaceholder() => Center(
    child: Icon(
      Icons.image_not_supported_outlined,
      size: errorIconSize,
      color: const Color(0xFF8B98A5),
    ),
  );
}
