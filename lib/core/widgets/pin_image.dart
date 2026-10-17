import 'package:flutter/material.dart';

import '../../features/pin/models/pin.dart';

/// Gambar pin dari assets (atau dari kamera lewat [Pin.bytes]). Kalau file belum ada, tampil kotak berwarna.
class PinImage extends StatelessWidget {
  final Pin pin;
  const PinImage(this.pin, {super.key});

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
    return Image.asset(
      pin.image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        color: pin.fallback,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: Colors.white54),
      ),
    );
  }
}
