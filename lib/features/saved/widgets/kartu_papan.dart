import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/waktu_relatif.dart';
import '../../../core/widgets/sampul_papan.dart';
import '../../pin/models/pin.dart';

/// Kartu papan: sampul + nama + "N Pin  waktu". Dipakai di tab Papan
/// (Disimpan) dan di profil > Disimpan.
class KartuPapan extends StatelessWidget {
  const KartuPapan({
    super.key,
    required this.nama,
    required this.pins,
    required this.jumlah,
    this.waktu,
    this.privat = false,
    this.onTap,
    this.onLongPress,
  });

  final String nama;

  /// Pin untuk sampul (maksimal 3 yang dipakai).
  final List<Pin> pins;
  final int jumlah;
  final DateTime? waktu;
  final bool privat;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SampulPapan(pins: pins.take(3).toList()),
              if (privat)
                Positioned(
                  left: 6,
                  top: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xE6FFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_outline, size: 14, color: Colors.black),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2, top: 1),
            child: Row(
              children: [
                Text(
                  '$jumlah Pin',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
                if (waktu != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    waktuRelatif(waktu!),
                    style: const TextStyle(fontSize: 11.5, color: AppColors.hint),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Susun [anak] menjadi grid 2 kolom (tinggi tiap baris mengikuti isinya).
class GridDuaKolom extends StatelessWidget {
  const GridDuaKolom({super.key, required this.anak});

  final List<Widget> anak;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        const jarak = 12.0;
        final lebar = (box.maxWidth - jarak) / 2;
        return Wrap(
          spacing: jarak,
          runSpacing: 16,
          children: [for (final a in anak) SizedBox(width: lebar, child: a)],
        );
      },
    );
  }
}
