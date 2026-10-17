import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Logo Pinspire: lingkaran merah dengan huruf "P" putih.
class PinspireLogo extends StatelessWidget {
  const PinspireLogo({super.key, this.ukuran = 48});

  final double ukuran;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.merah,
        shape: BoxShape.circle,
      ),
      child: Text(
        'P',
        style: TextStyle(
          color: Colors.white,
          fontSize: ukuran * 0.62,
          fontWeight: FontWeight.w800,
          height: 1,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
