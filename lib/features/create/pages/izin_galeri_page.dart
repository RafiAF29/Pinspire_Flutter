import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../data/gallery_access_store.dart';
import 'galeri_page.dart';

enum _Izin { terbatas, semua, tolak }

/// Layar gelap "Izinkan akses untuk melanjutkan" + dialog izin Android.
/// Hanya muncul untuk akun yang belum pernah memilih "Allow all".
class IzinGaleriPage extends StatefulWidget {
  const IzinGaleriPage({super.key});

  @override
  State<IzinGaleriPage> createState() => _IzinGaleriPageState();
}

class _IzinGaleriPageState extends State<IzinGaleriPage> {
  static const _latar = Color(0xFF2B2B27);

  @override
  void initState() {
    super.initState();
    // Dialog langsung muncul begitu layar tampil (sesuai screenshot).
    WidgetsBinding.instance.addPostFrameCallback((_) => _tampilDialog());
  }

  Future<void> _tampilDialog() async {
    if (!mounted) return;
    final hasil = await showModalBottomSheet<_Izin>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const _DialogIzin(),
    );
    if (!mounted || hasil == null || hasil == _Izin.tolak) return;

    if (hasil == _Izin.semua) GalleryAccessStore.instance.izinkanSemua();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const GaleriPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _latar,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AppStrings.permTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE9E9E4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.permBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.3,
                    color: Color(0xFFE0E0DA),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF55554F)),
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(fontSize: 10, color: Color(0xFF77776F)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      AppStrings.permGallery,
                      style: TextStyle(fontSize: 14, color: Color(0xFF77776F)),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: _tampilDialog,
                  child: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      AppStrings.permButton,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dialog izin gaya Android: kartu putih melayang di bawah.
class _DialogIzin extends StatelessWidget {
  const _DialogIzin();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.photo_library_outlined,
                  size: 26, color: Color(0xFF3B6EA8)),
              const SizedBox(height: 14),
              const Text(
                AppStrings.permDialog,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 10),
              _Opsi(AppStrings.permLimited, _Izin.terbatas),
              _Opsi(AppStrings.permAll, _Izin.semua),
              _Opsi(AppStrings.permDeny, _Izin.tolak),
            ],
          ),
        ),
      ),
    );
  }
}

class _Opsi extends StatelessWidget {
  final String label;
  final _Izin nilai;
  const _Opsi(this.label, this.nilai);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(nilai),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
