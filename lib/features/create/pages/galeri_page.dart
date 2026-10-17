import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../data/galeri_data.dart';
import 'buat_pin_page.dart';
import 'kamera_page.dart';

/// Pemilih foto/video: Semua | Video | Foto, dikelompokkan per tanggal.
/// Bisa pilih banyak item (badge bernomor sesuai urutan pilih) -> tombol
/// "Berikutnya" merah + deretan thumbnail di bawah. Ikon kamera membuka
/// alur kamera (izin hanya diminta sekali per akun).
class GaleriPage extends StatefulWidget {
  const GaleriPage({super.key});

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
  static const _maksPilih = 20;

  int _tab = 0; // 0 Semua, 1 Video, 2 Foto

  /// Urutan list = urutan pilih (nomor badge).
  final List<GaleriItem> _terpilih = [];

  List<GaleriItem> get _tampil => galeriItems.where((e) {
        if (_tab == 1) return e.video;
        if (_tab == 2) return !e.video;
        return true;
      }).toList();

  int _nomor(GaleriItem item) => _terpilih.indexWhere((e) => e.id == item.id);

  void _pilih(GaleriItem item) {
    setState(() {
      final i = _nomor(item);
      if (i >= 0) {
        _terpilih.removeAt(i);
      } else if (_terpilih.length < _maksPilih) {
        _terpilih.add(item);
      }
    });
  }

  void _lepas(GaleriItem item) {
    setState(() => _terpilih.removeWhere((e) => e.id == item.id));
  }

  void _lanjut() {
    if (_terpilih.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BuatPinPage(items: List.of(_terpilih)),
      ),
    );
  }

  /// Izin kamera/audio diminta sistem (HP/browser) sekali; setelah diizinkan
  /// tidak ditanya lagi.
  void _bukaKamera() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const KameraPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _bar(),
            _tabs(),
            Expanded(
              child: Stack(
                children: [
                  _grid(),
                  if (_terpilih.isEmpty)
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 18,
                      child: _TombolBawah(onKamera: _bukaKamera),
                    ),
                ],
              ),
            ),
            if (_terpilih.isNotEmpty) _strip(),
          ],
        ),
      ),
    );
  }

  Widget _bar() {
    final aktif = _terpilih.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, size: 28, color: Colors.black),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.help_outline, size: 28, color: Colors.black),
          const SizedBox(width: 20),
          const Text(
            AppStrings.allPhotos,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 22, color: Colors.black),
          const Spacer(),
          GestureDetector(
            onTap: aktif ? _lanjut : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: aktif ? AppColors.red : AppColors.chipGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppStrings.next,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: aktif ? Colors.white : const Color(0xFF9A9A92),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    const label = [AppStrings.tabAll, AppStrings.tabVideo, AppStrings.tabPhoto];
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: Row(
        children: [
          for (var i = 0; i < label.length; i++) ...[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _tab = i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label[i],
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2,
                    width: i == _tab ? 38 : 0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 22),
          ],
        ],
      ),
    );
  }

  Widget _grid() {
    // Kelompokkan per tanggal (urutan asli dipertahankan).
    final grup = <String, List<GaleriItem>>{};
    for (final e in _tampil) {
      grup.putIfAbsent(e.tanggal, () => []).add(e);
    }

    return CustomScrollView(
      slivers: [
        for (final entri in grup.entries) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              child: Text(
                entri.key,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _tile(entri.value[i]),
              childCount: entri.value.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 90)),
      ],
    );
  }

  Widget _tile(GaleriItem item) {
    final nomor = _nomor(item);
    final dipilih = nomor >= 0;
    return GestureDetector(
      key: ValueKey('galeri-${item.id}'),
      onTap: () => _pilih(item),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            item.asset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const ColoredBox(color: Color(0xFFBDBDB5)),
          ),
          if (item.video)
            Positioned(
              left: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.durasi!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (dipilih) ...[
            const ColoredBox(color: Color(0x66000000)),
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  '${nomor + 1}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Banner (kalau lebih dari satu) + deretan thumbnail terpilih, tiap
  /// thumbnail punya tombol x untuk membatalkan pilihan.
  Widget _strip() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_terpilih.length > 1)
            Container(
              color: AppColors.chipGrey,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: const Text(
                AppStrings.multiAssets,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            child: SizedBox(
              height: 62,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _terpilih.length,
                separatorBuilder: (context, i) => const SizedBox(width: 6),
                itemBuilder: (context, i) => _thumb(_terpilih[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumb(GaleriItem item) {
    return SizedBox(
      key: ValueKey('terpilih-${item.id}'),
      width: 58,
      height: 62,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.asset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const ColoredBox(color: Color(0xFFBDBDB5)),
              ),
            ),
          ),
          Positioned(
            right: 4,
            top: 0,
            child: GestureDetector(
              onTap: () => _lepas(item),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xCC55554F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 13, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol melayang di bawah grid: kamera + globe (kiri), folder "0" (kanan).
class _TombolBawah extends StatelessWidget {
  final VoidCallback onKamera;
  const _TombolBawah({required this.onKamera});

  Widget _bulat(IconData icon, {VoidCallback? onTap}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.chipGrey,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: Colors.black),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _bulat(Icons.photo_camera_outlined, onTap: onKamera),
        const SizedBox(width: 10),
        _bulat(Icons.public),
        const Spacer(),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.chipGrey,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 24,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '0',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
