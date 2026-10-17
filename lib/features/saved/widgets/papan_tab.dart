import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pin_image.dart';
import '../../create/data/board_store.dart';
import '../../create/pages/papan_page.dart';
import '../../pin/data/saved_store.dart';
import '../../pin/models/pin.dart';
import '../../pin_detail/screens/pin_detail_screen.dart';
import 'bagian_saved.dart';
import 'kartu_papan.dart';

/// Disimpan > Papan: daftar papan, "Baru-baru ini dihapus", "Ide belum diatur".
class PapanTab extends StatefulWidget {
  const PapanTab({super.key});

  @override
  State<PapanTab> createState() => _PapanTabState();
}

class _PapanTabState extends State<PapanTab> {
  bool _hanyaGroup = false;
  bool _hanyaPrivat = false;

  void _tanyaHapus(Board papan) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.chipGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 6),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.black),
              title: Text(
                '${AppStrings.deleteBoard} "${papan.name}"',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                BoardStore.instance.hapus(papan);
                Navigator.of(sheetContext).pop();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final papanStore = BoardStore.instance;
    final saved = SavedStore.instance;

    return AnimatedBuilder(
      animation: Listenable.merge([papanStore, saved]),
      builder: (context, _) {
        // "Group" belum punya data (belum ada papan kelompok), jadi kosong.
        final papan = _hanyaGroup
            ? <Board>[]
            : [
                for (final b in papanStore.boards)
                  if (!_hanyaPrivat || b.privat) b,
              ];
        final belumDiatur = [
          for (final p in saved.pins)
            if (!papanStore.pinSudahDiPapan(p)) p,
        ];
        final dihapus = papanStore.dihapus;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BarisCariPin(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.chipGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.swap_vert, size: 18, color: Colors.black),
                        Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  ChipSaved(
                    label: AppStrings.group,
                    aktif: _hanyaGroup,
                    onTap: () => setState(() => _hanyaGroup = !_hanyaGroup),
                  ),
                  const SizedBox(width: 6),
                  ChipSaved(
                    label: AppStrings.private,
                    aktif: _hanyaPrivat,
                    onTap: () => setState(() => _hanyaPrivat = !_hanyaPrivat),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: GridDuaKolom(
                  anak: [
                    for (final b in papan)
                      KartuPapan(
                        key: ValueKey('kartu-papan-${b.id}'),
                        nama: b.name,
                        pins: b.pins,
                        jumlah: b.pins.length,
                        waktu: b.terakhirDiubah ?? b.dibuat,
                        privat: b.privat,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PapanPage(board: b),
                          ),
                        ),
                        onLongPress: () => _tanyaHapus(b),
                      ),
                  ],
                ),
              ),
              if (dihapus.isNotEmpty) ...[
                const SizedBox(height: 26),
                _judul(
                  AppStrings.recentlyDeleted,
                  TombolBagian(
                    label: AppStrings.restore,
                    onTap: papanStore.pulihkan,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 6, 40, 0),
                  child: Text(
                    AppStrings.deletedBoards(dihapus.length),
                    style: const TextStyle(fontSize: 13, height: 1.3),
                  ),
                ),
              ],
              if (belumDiatur.isNotEmpty) ...[
                const SizedBox(height: 26),
                _judul(
                  AppStrings.unorganizedIdeas,
                  const TombolBagian(label: AppStrings.organize),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 104,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemCount: belumDiatur.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => _Mungil(pin: belumDiatur[i]),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _judul(String teks, Widget tombol) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                teks,
                style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
              ),
            ),
            tombol,
          ],
        ),
      );
}

class _Mungil extends StatelessWidget {
  const _Mungil({required this.pin});

  final Pin pin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => PinDetailScreen(pin: pin)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(width: 78, height: 104, child: PinImage(pin)),
      ),
    );
  }
}
