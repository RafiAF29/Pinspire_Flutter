import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../create/pages/kamera_page.dart';
import '../data/search_repository.dart';
import '../pages/search_input_page.dart';
import '../pages/search_results_page.dart';

/// Tab Cari: slide besar + bagian-bagian ide. Kolom pencarian melayang di
/// atas (tetap terlihat saat halaman digulir).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PageController _halaman = PageController();
  int _slide = 0;

  @override
  void dispose() {
    _halaman.dispose();
    super.dispose();
  }

  void _bukaKamera() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const KameraPage(untukCari: true)),
    );
  }

  Future<void> _bukaInput() async {
    final q = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const SearchInputPage()),
    );
    if (q == null || !mounted) return;
    _bukaHasil(q);
  }

  void _bukaHasil(String q) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => SearchResultsPage(query: q)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = SearchRepository.instance;
    final atas = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 270 + atas,
              child: PageView.builder(
                controller: _halaman,
                itemCount: repo.slide.length,
                onPageChanged: (i) => setState(() => _slide = i),
                itemBuilder: (context, i) => _SlideBesar(
                  slide: repo.slide[i],
                  onTap: () => _bukaHasil(repo.slide[i].judul),
                ),
              ),
            ),
            _Titik(jumlah: repo.slide.length, aktif: _slide),
            for (final b in repo.bagian)
              _Bagian(data: b, onTap: () => _bukaHasil(b.judul)),
            const SizedBox(height: 24),
          ],
        ),
        Positioned(
          left: 12,
          right: 12,
          top: atas + 8,
          child: _KolomCari(onTap: _bukaInput, onKamera: _bukaKamera),
        ),
      ],
    );
  }
}

/// Kolom "Cari ide" yang melayang di atas halaman.
class _KolomCari extends StatelessWidget {
  const _KolomCari({required this.onTap, required this.onKamera});

  final VoidCallback onTap;
  final VoidCallback onKamera;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.garis),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20, color: Colors.black),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                AppStrings.searchHint,
                style: TextStyle(fontSize: 15, color: AppColors.hint),
              ),
            ),
            GestureDetector(
              key: const ValueKey('cari-kamera'),
              behavior: HitTestBehavior.opaque,
              onTap: onKamera,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.photo_camera_outlined, size: 22, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideBesar extends StatelessWidget {
  const _SlideBesar({required this.slide, required this.onTap});

  final SlideJelajah slide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final teks = AppConfig.gambarHalamanCari ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (AppConfig.gambarHalamanCari)
            Image.asset(
              slide.gambar,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF3A3A35)),
            )
          else
            const ColoredBox(color: AppColors.chipGrey),
          // Gradien gelap di bawah agar teks putih terbaca.
          if (AppConfig.gambarHalamanCari)
            const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0x00000000), Color(0xAA000000)],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
          // Pudar putih tipis di atas agar ikon status bar tetap terbaca.
          if (AppConfig.gambarHalamanCari)
            const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 90,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x99FFFFFF), Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slide.label,
                  style: TextStyle(fontSize: 12, color: teks),
                ),
                const SizedBox(height: 2),
                Text(
                  slide.judul,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: teks,
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

/// Titik indikator slide.
class _Titik extends StatelessWidget {
  const _Titik({required this.jumlah, required this.aktif});

  final int jumlah;
  final int aktif;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < jumlah; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == aktif ? 8 : 6,
              height: i == aktif ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == aktif ? Colors.black : const Color(0xFFC9C9C2),
              ),
            ),
        ],
      ),
    );
  }
}

/// Satu bagian: label kecil, judul tebal, tombol kaca pembesar, 4 foto berjajar.
class _Bagian extends StatelessWidget {
  const _Bagian({required this.data, required this.onTap});

  final BagianJelajah data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.label,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.teksSekunder,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        data.judul,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.chipGrey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search, size: 18, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 2.3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < data.gambar.length; i++)
                      Expanded(
                        child: AppConfig.gambarHalamanCari
                            ? Image.asset(
                                data.gambar[i],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const ColoredBox(color: AppColors.chipGrey),
                              )
                            // Kosong dulu: sekat tipis antar kotak.
                            : Padding(
                                padding: EdgeInsets.only(left: i == 0 ? 0 : 2),
                                child: const ColoredBox(color: AppColors.chipGrey),
                              ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
