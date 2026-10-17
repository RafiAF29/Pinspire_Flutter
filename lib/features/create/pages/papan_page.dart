import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/masonry_grid.dart';
import '../../pin/models/pin.dart';
import '../../../core/widgets/pin_image.dart';
import '../../pin_detail/screens/pin_detail_screen.dart';
import '../data/board_store.dart';
import 'tambah_pin_page.dart';

/// Halaman sebuah papan: judul, jumlah Pin, tab, dan isi papan.
/// Tombol kembali -> kembali ke formulir Buat Pin (papan sudah terpilih).
class PapanPage extends StatelessWidget {
  final Board board;
  const PapanPage({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: BoardStore.instance,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _atas(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      board.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _info(),
                  _tab(),
                  _urut(),
                  Expanded(child: _isi(context)),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: _BarMelayang(
                  onTambah: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TambahPinPage(board: board),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _atas(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_left, size: 32, color: Colors.black),
            ),
          ),
          const Spacer(),
          const Icon(Icons.person_add_alt_1_outlined,
              size: 26, color: Colors.black),
          const SizedBox(width: 18),
          const Icon(Icons.more_horiz, size: 28, color: Colors.black),
        ],
      ),
    );
  }

  Widget _info() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.chipGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  board.privat ? Icons.lock_outline : Icons.public,
                  size: 14,
                  color: Colors.black,
                ),
                const SizedBox(width: 5),
                Text(
                  board.privat
                      ? AppStrings.privateBoard
                      : AppStrings.publicBoard,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text('·', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            '${board.pins.length} Pin',
            style: const TextStyle(fontSize: 12.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _tab() {
    Widget item(String teks, bool pilih) => Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                teks,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Container(
                height: 2,
                width: pilih ? 92 : 0,
                color: Colors.black,
              ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Row(
        children: [
          item(AppStrings.moreIdeas, false),
          item(AppStrings.allSaves, true),
        ],
      ),
    );
  }

  Widget _urut() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 8),
      child: Row(
        children: [
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.chipGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.swap_vert, size: 18, color: Colors.black),
                SizedBox(width: 4),
                Text(
                  AppStrings.lastSaved,
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Icon(Icons.tune, size: 24, color: Colors.black),
        ],
      ),
    );
  }

  Widget _isi(BuildContext context) {
    if (board.pins.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 60, 0),
        child: Text(
          AppStrings.emptyBoard,
          style: TextStyle(fontSize: 13.5, height: 1.3),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 90),
      child: MasonryGrid<Pin>(
        items: board.pins,
        columns: 2,
        crossSpacing: 6,
        mainSpacing: 0,
        extraRatio: 0.12,
        aspectOf: (p) => p.aspect,
        itemBuilder: (context, p) => GestureDetector(
          key: ValueKey('papan-pin-${p.id}'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => PinDetailScreen(pin: p)),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: p.aspect,
                  child: PinImage(p),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 6, 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.star_border, size: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bar melayang di bawah: Atur | Tambahkan | Ide lainnya.
class _BarMelayang extends StatelessWidget {
  const _BarMelayang({required this.onTambah});

  final VoidCallback onTambah;

  Widget _item(IconData icon, String label, [VoidCallback? onTap]) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item(Icons.dashboard_customize_outlined, AppStrings.arrange),
          _item(Icons.add, AppStrings.add, onTambah),
          _item(Icons.auto_awesome_outlined, AppStrings.moreIdeas),
        ],
      ),
    );
  }
}
