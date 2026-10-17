import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PinButtonGaya {
  /// Merah (aksi utama). Abu-abu bila nonaktif.
  utama,

  /// Putih dengan garis pinggir (mis. "Lanjutkan dengan Google").
  sekunder,

  /// Abu muda (mis. pilihan jenis kelamin).
  netral,
}

class PinButton extends StatelessWidget {
  const PinButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gaya = PinButtonGaya.utama,
    this.leading,
    this.tinggi = 48,
    this.memuat = false,
  });

  final String label;

  /// Null = tombol nonaktif.
  final VoidCallback? onPressed;
  final PinButtonGaya gaya;

  /// Ikon di sisi kiri (teks tetap di tengah).
  final Widget? leading;
  final double tinggi;

  /// Tampilkan spinner menggantikan teks.
  final bool memuat;

  @override
  Widget build(BuildContext context) {
    final nonaktif = onPressed == null;

    late final Color latar;
    late final Color warnaTeks;
    BorderSide sisi = BorderSide.none;

    switch (gaya) {
      case PinButtonGaya.utama:
        latar = nonaktif ? AppColors.abuMuda : AppColors.merah;
        warnaTeks = nonaktif ? AppColors.teksHint : Colors.white;
      case PinButtonGaya.sekunder:
        latar = Colors.white;
        warnaTeks = AppColors.teks;
        sisi = const BorderSide(color: AppColors.garis);
      case PinButtonGaya.netral:
        latar = AppColors.abuMuda;
        warnaTeks = AppColors.teks;
    }

    return SizedBox(
      width: double.infinity,
      height: tinggi,
      child: Material(
        color: latar,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: sisi,
        ),
        child: InkWell(
          onTap: (nonaktif || memuat) ? null : onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (leading != null) Positioned(left: 16, child: leading!),
              if (memuat)
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: warnaTeks,
                  ),
                )
              else
                Text(
                  label,
                  style: TextStyle(
                    color: warnaTeks,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
