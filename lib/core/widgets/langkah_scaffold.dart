import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'pin_button.dart';
import 'step_dots.dart';

/// Kerangka halaman langkah registrasi: tombol kembali + titik langkah di atas,
/// judul & subjudul di tengah, tombol "Berikutnya" merah di bawah.
class LangkahScaffold extends StatelessWidget {
  const LangkahScaffold({
    super.key,
    required this.totalLangkah,
    required this.langkahSaatIni,
    required this.judul,
    required this.child,
    this.subjudul,
    this.labelTombol,
    this.onLanjut,
  });

  final int totalLangkah;
  final int langkahSaatIni;
  final String judul;
  final String? subjudul;

  /// Isi halaman (di bawah judul).
  final Widget child;

  /// Teks tombol bawah. Null = tidak ada tombol bawah.
  final String? labelTombol;

  /// Null = tombol bawah nonaktif (abu-abu).
  final VoidCallback? onLanjut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 34,
                        color: AppColors.teksSekunder,
                      ),
                    ),
                  ),
                  StepDots(total: totalLangkah, saatIni: langkahSaatIni),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                judul,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: AppColors.teks,
                ),
              ),
            ),
            if (subjudul != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  subjudul!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.35,
                    color: AppColors.teks,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Expanded(child: child),
            if (labelTombol != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: PinButton(label: labelTombol!, onPressed: onLanjut),
              ),
          ],
        ),
      ),
    );
  }
}
