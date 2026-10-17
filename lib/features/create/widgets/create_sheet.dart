import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../data/gallery_access_store.dart';
import '../pages/galeri_page.dart';
import '../pages/izin_galeri_page.dart';
import '../pages/tambah_pin_page.dart';
import 'buat_papan_sheet.dart';
import 'sheet_header.dart';

/// Sheet "Mulai berkreasi sekarang" (muncul saat tombol + / Buat ditekan).
Future<void> showCreateSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          SheetHeader(
            title: AppStrings.createSheetTitle,
            icon: Icons.close,
            onTap: () => Navigator.of(sheetContext).pop(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Pilihan(
                icon: Icons.push_pin_outlined,
                label: AppStrings.createPin,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  mulaiBuatPin(context);
                },
              ),
              const SizedBox(width: 14),
              const _Pilihan(
                icon: Icons.content_cut,
                label: AppStrings.createCollage,
              ),
              const SizedBox(width: 14),
              _Pilihan(
                icon: Icons.dashboard_outlined,
                label: AppStrings.createBoard,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  mulaiBuatPapan(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

/// Pin -> kalau akun ini belum "Allow all": layar izin dulu, kalau sudah:
/// langsung ke galeri.
void mulaiBuatPin(BuildContext context) {
  final nav = Navigator.of(context);
  final sudah = GalleryAccessStore.instance.sudahIzinkanSemua;
  nav.push(MaterialPageRoute<void>(
    builder: (_) => sudah ? const GaleriPage() : const IzinGaleriPage(),
  ));
}

/// Papan -> sheet "Buat papan"; kalau berhasil dibuat lanjut ke halaman
/// "Tambahkan Pin", lalu halaman papan.
Future<void> mulaiBuatPapan(BuildContext context) async {
  final papan = await showBuatPapanSheet(context, ikonKiri: Icons.close);
  if (papan == null || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => TambahPinPage(board: papan, lanjutKePapan: true),
    ),
  );
}

class _Pilihan extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _Pilihan({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.chipGrey,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 24, color: Colors.black),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
