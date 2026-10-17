import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Kartu "Memuat ..." di tengah layar (seperti saat proses masuk di Pinterest).
/// Tutup dengan [tutupDialogMemuat].
Future<void> tampilkanDialogMemuat(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    builder: (_) => PopScope(
      canPop: false,
      child: Center(
        child: Material(
          color: Colors.white,
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 260),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.kekuatan,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Memuat ...',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.teks,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void tutupDialogMemuat(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
