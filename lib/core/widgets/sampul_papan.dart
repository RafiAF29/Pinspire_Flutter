import 'package:flutter/material.dart';

import '../../features/pin/models/pin.dart';
import 'pin_image.dart';

/// Sampul papan: satu foto besar di kiri + dua foto kecil di kanan.
/// Bagian yang belum ada Pin-nya tampil sebagai kotak abu-abu muda.
class SampulPapan extends StatelessWidget {
  const SampulPapan({super.key, required this.pins, this.rasio = 1.5});

  final List<Pin> pins;

  /// lebar / tinggi.
  final double rasio;

  static const Color _kosong = Color(0xFFF1F1EC);

  Widget _petak(int i) {
    if (i >= pins.length) return const ColoredBox(color: _kosong);
    return PinImage(pins[i]);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: rasio,
        child: pins.isEmpty
            ? const ColoredBox(color: _kosong)
            : Row(
                children: [
                  Expanded(flex: 2, child: SizedBox.expand(child: _petak(0))),
                  const SizedBox(width: 1.5),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: SizedBox.expand(child: _petak(1))),
                        const SizedBox(height: 1.5),
                        Expanded(child: SizedBox.expand(child: _petak(2))),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
