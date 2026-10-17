import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Judul halaman: ikon di kiri (panah kembali / X), teks tebal di tengah,
/// dan widget opsional di kanan (mis. tombol "Selesai").
class HeaderHalaman extends StatelessWidget {
  const HeaderHalaman({
    super.key,
    required this.judul,
    required this.onKiri,
    this.ikonKiri = Icons.chevron_left,
    this.kanan,
  });

  final String judul;
  final VoidCallback onKiri;
  final IconData ikonKiri;
  final Widget? kanan;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onKiri,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(ikonKiri, size: 28, color: Colors.black),
              ),
            ),
          ),
          Center(
            child: Text(
              judul,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          if (kanan != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: kanan,
              ),
            ),
        ],
      ),
    );
  }
}

/// Tombol pil kecil di header ("Selesai"): abu-abu bila nonaktif, merah bila aktif.
class TombolPil extends StatelessWidget {
  const TombolPil({
    super.key,
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  final String label;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: aktif ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: aktif ? AppColors.red : AppColors.chipGrey,
          borderRadius: BorderRadius.circular(18),
        ),
        // widthFactor: 1 -> lebar pil mengikuti teks (bukan memenuhi layar).
        child: Center(
          widthFactor: 1,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : const Color(0xFF9A9A92),
            ),
          ),
        ),
      ),
    );
  }
}
