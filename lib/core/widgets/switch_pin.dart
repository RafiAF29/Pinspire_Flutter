import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Switch bergaya Pinterest (biru saat aktif, abu-abu saat mati).
class SwitchPin extends StatelessWidget {
  const SwitchPin({super.key, required this.nilai, required this.onChanged});

  final bool nilai;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: nilai,
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (s) => s.contains(WidgetState.selected)
            ? Colors.white
            : const Color(0xFF76766B),
      ),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (s) => s.contains(WidgetState.selected)
            ? const Color(0xFF4355DB)
            : AppColors.chipGrey,
      ),
      trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
    );
  }
}
