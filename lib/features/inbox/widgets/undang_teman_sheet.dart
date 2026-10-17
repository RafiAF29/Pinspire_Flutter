import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pin_image.dart';
import '../../../core/widgets/pinspire_logo.dart';
import '../../create/data/board_store.dart';
import '../../pin/data/saved_store.dart';
import '../../profile/data/profil_store.dart';
import '../../profile/pages/edit_profil_sheet.dart';

/// Sheet "Bagikan tautan profil" (tampilan 2): kartu profil + pilihan
/// aplikasi untuk membagikan tautan. Muncul saat "Undang teman-teman Anda"
/// ditekan.
Future<void> tampilkanUndangTeman(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    barrierColor: const Color(0x33000000),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => _UndangTemanSheet(luar: context),
  );
}

class _UndangTemanSheet extends StatelessWidget {
  const _UndangTemanSheet({required this.luar});

  /// Context di bawah sheet, dipakai untuk membuka sheet "Edit profil".
  final BuildContext luar;

  String _tautan(DataProfil p) => 'https://pinspire.app/${p.namaPengguna}';

  void _bagikan(BuildContext context, String app) {
    final pesan = ScaffoldMessenger.of(luar);
    Navigator.of(context).pop();
    pesan.showSnackBar(
      SnackBar(
        content: Text(AppStrings.shareVia(app)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _salin(BuildContext context, DataProfil p) async {
    final pesan = ScaffoldMessenger.of(luar);
    await Clipboard.setData(ClipboardData(text: _tautan(p)));
    if (!context.mounted) return;
    Navigator.of(context).pop();
    pesan.showSnackBar(
      const SnackBar(
        content: Text(AppStrings.linkCopied),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profil = ProfilStore.instance.saatIni;

    final baris1 = <_Aplikasi>[
      _Aplikasi(
        label: AppStrings.shareWhatsapp,
        ikon: const _IkonBulat(
          warna: Color(0xFF25D366),
          anak: Icon(Icons.phone, size: 26, color: Colors.white),
        ),
        onTap: () => _bagikan(context, AppStrings.shareWhatsapp),
      ),
      _Aplikasi(
        label: AppStrings.copyLink,
        ikon: const _IkonBulat(
          warna: AppColors.chipGrey,
          anak: Icon(Icons.link, size: 28, color: Colors.black),
        ),
        onTap: () => _salin(context, profil),
      ),
      _Aplikasi(
        label: AppStrings.shareTelegram,
        ikon: _IkonBulat(
          warna: const Color(0xFF229ED9),
          anak: Transform.rotate(
            angle: -0.5,
            child: const Padding(
              padding: EdgeInsets.only(left: 3),
              child: Icon(Icons.send, size: 24, color: Colors.white),
            ),
          ),
        ),
        onTap: () => _bagikan(context, AppStrings.shareTelegram),
      ),
      _Aplikasi(
        label: AppStrings.shareGoogleMessages,
        ikon: const _IkonBulat(
          warna: Colors.white,
          bergaris: true,
          anak: Icon(Icons.chat_bubble, size: 26, color: Color(0xFF1A73E8)),
        ),
        onTap: () => _bagikan(context, AppStrings.shareGoogleMessages),
      ),
    ];

    final baris2 = <_Aplikasi>[
      _Aplikasi(
        label: AppStrings.shareInstagram,
        ikon: const _IkonInstagram(),
        onTap: () => _bagikan(context, AppStrings.shareInstagram),
      ),
      _Aplikasi(
        label: AppStrings.shareGmail,
        ikon: const _IkonBulat(
          warna: Colors.white,
          bergaris: true,
          anak: Text(
            'M',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFFEA4335),
              height: 1,
            ),
          ),
        ),
        onTap: () => _bagikan(context, AppStrings.shareGmail),
      ),
      _Aplikasi(
        label: AppStrings.shareMessage,
        ikon: const PinspireLogo(ukuran: 56),
        onTap: () => _bagikan(context, AppStrings.shareMessage),
      ),
      _Aplikasi(
        label: AppStrings.shareMore,
        ikon: const _IkonBulat(
          warna: AppColors.chipGrey,
          anak: Icon(Icons.more_horiz, size: 28, color: Colors.black),
        ),
        onTap: () => _bagikan(context, AppStrings.shareMore),
      ),
    ];

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.garis,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    ProfilStore.instance,
                    SavedStore.instance,
                    BoardStore.instance,
                  ]),
                  builder: (context, _) => _KartuProfil(
                    profil: ProfilStore.instance.saatIni,
                    jumlahPin: SavedStore.instance.pins.length,
                    jumlahPapan: BoardStore.instance.boards.length,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    if (luar.mounted) tampilkanEditProfil(luar);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined, size: 14, color: Colors.black),
                        SizedBox(width: 6),
                        Text(
                          AppStrings.editingYourProfile,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                AppStrings.shareProfileLink,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _BarisAplikasi(items: baris1),
              const SizedBox(height: 14),
              _BarisAplikasi(items: baris2),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu profil dengan sampul kolase dan avatar di tengah.
class _KartuProfil extends StatelessWidget {
  const _KartuProfil({
    required this.profil,
    required this.jumlahPin,
    required this.jumlahPapan,
  });

  final DataProfil profil;
  final int jumlahPin;
  final int jumlahPapan;

  static const Color _kosong = Color(0xFFF1F1EC);

  @override
  Widget build(BuildContext context) {
    final pins = SavedStore.instance.pins;

    Widget petak(int i) => i < pins.length
        ? PinImage(pins[i])
        : const ColoredBox(color: _kosong);

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.garis),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Row(
                      children: [
                        Expanded(child: SizedBox.expand(child: petak(0))),
                        const SizedBox(width: 1.5),
                        Expanded(child: SizedBox.expand(child: petak(1))),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 62,
                  height: 62,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.avatarGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    profil.inisial,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profil.namaPengguna,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.pinBoardCount(jumlahPin, jumlahPapan),
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Aplikasi {
  const _Aplikasi({
    required this.label,
    required this.ikon,
    required this.onTap,
  });

  final String label;
  final Widget ikon;
  final VoidCallback onTap;
}

class _BarisAplikasi extends StatelessWidget {
  const _BarisAplikasi({required this.items});

  final List<_Aplikasi> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final a in items)
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: a.onTap,
              child: Column(
                children: [
                  a.ikon,
                  const SizedBox(height: 6),
                  Text(
                    a.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Lingkaran 56px berisi ikon / huruf (logo aplikasi sederhana).
class _IkonBulat extends StatelessWidget {
  const _IkonBulat({
    required this.warna,
    required this.anak,
    this.bergaris = false,
  });

  final Color warna;
  final Widget anak;
  final bool bergaris;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: warna,
        shape: BoxShape.circle,
        border: bergaris ? Border.all(color: AppColors.garis) : null,
      ),
      child: anak,
    );
  }
}

/// Logo Instagram: kotak bulat gradasi dengan kamera putih.
class _IkonInstagram extends StatelessWidget {
  const _IkonInstagram();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFFFEDA77),
            Color(0xFFF58529),
            Color(0xFFDD2A7B),
            Color(0xFF8134AF),
            Color(0xFF515BD4),
          ],
        ),
      ),
      child: const Icon(Icons.photo_camera_outlined, size: 30, color: Colors.white),
    );
  }
}
