import 'package:flutter/material.dart';

import '../../features/pin/models/pin.dart';

/// Gambar pin: mendukung asset lokal, URL jaringan, dan hasil kamera (bytes).
/// Kalau file belum ada atau gagal dimuat, tampil kotak berwarna.
class PinImage extends StatelessWidget {
  final Pin pin;
  const PinImage(this.pin, {super.key});

  bool get _isUrl =>
      pin.image.startsWith('http://') || pin.image.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final bytes = pin.bytes;
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
      );
    }

    final errorWidget = Container(
      color: pin.fallback,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: Colors.white54),
    );

    // Gambar dari URL jaringan (REST API).
    if (_isUrl) {
      return Image.network(
        pin.image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: pin.fallback,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white54,
            ),
          );
        },
        errorBuilder: (_, _, _) => errorWidget,
      );
    }

    // Gambar dari asset lokal.
    return Image.asset(
      pin.image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => errorWidget,
    );
  }
}
