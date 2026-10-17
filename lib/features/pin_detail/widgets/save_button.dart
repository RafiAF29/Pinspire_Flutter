import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';

/// Tiga kondisi tombol di sebelah kanan baris aksi.
enum SaveButtonState {
  /// Belum disimpan: "Simpan" (merah).
  save,

  /// Baru saja disimpan: "Disimpan" (gelap, sebentar).
  saved,

  /// Sudah tersimpan: "Profil" (gelap) -> buka tab Disimpan.
  profile,
}

class SaveButton extends StatelessWidget {
  final SaveButtonState state;
  final VoidCallback? onTap;
  const SaveButton({super.key, required this.state, this.onTap});

  String get _label => switch (state) {
        SaveButtonState.save => AppStrings.save,
        SaveButtonState.saved => AppStrings.saved,
        SaveButtonState.profile => AppStrings.profile,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: state == SaveButtonState.save
                ? AppColors.red
                : AppColors.dark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              _label,
              key: ValueKey(_label),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
