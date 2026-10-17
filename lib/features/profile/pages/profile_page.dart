import 'package:flutter/material.dart';

import '../../../core/navigation/pindah_tab.dart';
import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/masonry_grid.dart';
import '../../create/data/board_store.dart';
import '../../create/pages/papan_page.dart';
import '../../create/widgets/create_sheet.dart';
import '../../pin/data/saved_store.dart';
import '../../pin/models/pin.dart';
import '../../pin/widgets/pin_card.dart';
import '../../saved/widgets/kartu_papan.dart';
import '../data/profil_store.dart';
import 'edit_profil_sheet.dart';
import 'tentang_page.dart';

/// Halaman profil (dibuka dengan mengetuk avatar di tab Disimpan).
/// Tab "Dibuat" = Pin buatan sendiri, "Disimpan" = daftar papan.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.tabAwal = 0});

  /// 0 = Dibuat, 1 = Disimpan.
  final int tabAwal;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int _tab = widget.tabAwal;

  Future<void> _ubahBio(DataProfil profil) async {
    final hasil = await bukaTentang(context, profil.bio);
    if (hasil != null) ProfilStore.instance.ubahBio(hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            ProfilStore.instance,
            SavedStore.instance,
            BoardStore.instance,
          ]),
          builder: (context, _) {
            final profil = ProfilStore.instance.saatIni;
            return Column(
              children: [
                _atas(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _kepala(profil),
                        const SizedBox(height: 22),
                        _tabs(),
                        const SizedBox(height: 4),
                        if (_tab == 0) _dibuat() else _disimpan(profil),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: PinBottomNav(
        index: 4,
        onTap: (i) => pindahTab(context, i),
      ),
    );
  }

  Widget _atas() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.chevron_left, size: 32, color: Colors.black),
            ),
          ),
          const Spacer(),
          const Icon(Icons.share_outlined, size: 24, color: Colors.black),
        ],
      ),
    );
  }

  Widget _kepala(DataProfil profil) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => tampilkanEditProfil(context),
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: AppColors.avatarGreen,
                        child: Text(
                          profil.inisial,
                          style: const TextStyle(fontSize: 34, color: Colors.black),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.navBorder),
                          ),
                          child: const Icon(Icons.edit, size: 13, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profil.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      profil.namaPengguna,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppColors.hint),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${profil.pengikut} ${AppStrings.followers} · '
            '${profil.mengikuti} ${AppStrings.following}',
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _ubahBio(profil),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    profil.bio.isEmpty ? AppStrings.bioHint : profil.bio,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.3,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.edit_outlined, size: 17, color: Colors.black),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => tampilkanEditProfil(context),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.chipGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                AppStrings.editProfile,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    Widget item(String teks, int i) {
      final pilih = _tab == i;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _tab = i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                teks,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: pilih ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Container(height: 2, width: pilih ? 56 : 0, color: Colors.black),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [item(AppStrings.created, 0), item(AppStrings.savedTab, 1)],
      ),
    );
  }

  Widget _dibuat() {
    final pins = SavedStore.instance.dibuat;
    if (pins.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 56),
        child: Center(
          child: Column(
            children: [
              const Text(
                AppStrings.inspireWithPins,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => mulaiBuatPin(context),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Text(
                    AppStrings.btnCreate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 0),
      child: MasonryGrid<Pin>(
        items: pins,
        columns: 2,
        crossSpacing: 6,
        mainSpacing: 0,
        extraRatio: 0.14,
        aspectOf: (p) => p.aspect,
        itemBuilder: (_, p) => PinCard(pin: p),
      ),
    );
  }

  Widget _disimpan(DataProfil profil) {
    final saved = SavedStore.instance;
    final papan = BoardStore.instance.boards;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: GridDuaKolom(
        anak: [
          if (profil.tampilkanSemuaPin)
            KartuPapan(
              nama: AppStrings.allPins,
              pins: saved.pins,
              jumlah: saved.pins.length,
              waktu: saved.terakhirDisimpan,
              // Semua Pin = tab Disimpan di navigasi bawah.
              onTap: () => pindahTab(context, 4),
            ),
          for (final b in papan)
            KartuPapan(
              key: ValueKey('profil-papan-${b.id}'),
              nama: b.name,
              pins: b.pins,
              jumlah: b.pins.length,
              waktu: b.terakhirDiubah ?? b.dibuat,
              privat: b.privat,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => PapanPage(board: b)),
              ),
            ),
        ],
      ),
    );
  }
}
