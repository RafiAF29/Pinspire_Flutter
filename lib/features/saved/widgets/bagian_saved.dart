import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../create/widgets/create_sheet.dart';

/// Kolom "Cari di Pin Anda" + tombol + (dipakai tab Pin & Papan).
/// Tombol + membuka sheet "Mulai berkreasi sekarang" (Pin / Kolase / Papan).
class BarisCariPin extends StatelessWidget {
  const BarisCariPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.outline),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 20, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  AppStrings.searchPins,
                  style: TextStyle(fontSize: 15, color: AppColors.hint),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showCreateSheet(context),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.add, size: 28, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

/// Chip abu-abu (atau gelap saat [aktif]).
class ChipSaved extends StatelessWidget {
  const ChipSaved({
    super.key,
    required this.label,
    this.ikon,
    this.aktif = false,
    this.onTap,
  });

  final String label;
  final IconData? ikon;
  final bool aktif;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final warnaTeks = aktif ? Colors.white : Colors.black;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: aktif ? AppColors.dark : AppColors.chipGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ikon != null) ...[
              Icon(ikon, size: 18, color: warnaTeks),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: warnaTeks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tombol abu-abu kecil di sisi kanan judul bagian ("Pulihkan", "Atur").
class TombolBagian extends StatelessWidget {
  const TombolBagian({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.chipGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
