import 'package:flutter/material.dart';

import '../data/galeri_data.dart';

/// Gambar satu media: hasil kamera (bytes) atau asset galeri tiruan.
class ItemImage extends StatelessWidget {
  final GaleriItem item;
  final BoxFit fit;
  const ItemImage(this.item, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final bytes = item.bytes;
    if (bytes != null) {
      return Image.memory(bytes, fit: fit, gaplessPlayback: true);
    }
    if (item.dariKamera) {
      // Video tanpa gambar sampul.
      return const ColoredBox(
        color: Color(0xFF3A3A35),
        child: Center(
          child: Icon(Icons.videocam_outlined, color: Colors.white54, size: 32),
        ),
      );
    }
    return Image.asset(
      item.asset,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          const ColoredBox(color: Color(0xFFBDBDB5)),
    );
  }
}
