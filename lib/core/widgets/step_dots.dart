import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Titik indikator langkah registrasi.
/// Langkah selesai = titik penuh, langkah aktif = cincin, sisanya abu-abu.
class StepDots extends StatelessWidget {
  const StepDots({super.key, required this.total, required this.saatIni});

  final int total;

  /// Nomor langkah aktif, dimulai dari 1.
  final int saatIni;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final nomor = i + 1;
        final selesai = nomor < saatIni;
        final aktif = nomor == saatIni;

        return Container(
          width: 9,
          height: 9,
          margin: const EdgeInsets.symmetric(horizontal: 4.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: aktif
                ? Colors.white
                : (selesai ? AppColors.teks : AppColors.garis),
            border: aktif ? Border.all(color: AppColors.teks, width: 2) : null,
          ),
        );
      }),
    );
  }
}
