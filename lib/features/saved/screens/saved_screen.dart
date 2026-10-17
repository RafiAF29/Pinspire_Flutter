import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/masonry_grid.dart';
import '../../../core/widgets/pin_image.dart';
import '../../../core/navigation/tab_state.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/pages/welcome_page.dart';
import '../../pin/data/saved_store.dart';
import '../../pin/models/pin.dart';
import '../../pin_detail/screens/pin_detail_screen.dart';
import '../../profile/data/profil_store.dart';
import '../../profile/pages/profile_page.dart';
import '../widgets/bagian_saved.dart';
import '../widgets/kolase_tab.dart';
import '../widgets/papan_tab.dart';

/// Tab Disimpan. Header: avatar (buka profil) + tab Pin | Papan | Kolase.
///
/// Tab Pin:
/// - Tap pin        -> buka detail.
/// - Tekan lama pin -> menu "Hapus dari Disimpan" (satu-satunya cara batal simpan).
/// Tab Papan: daftar papan. Tab Kolase: ajakan membuat kolase.
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  /// 0 = Pin, 1 = Papan, 2 = Kolase.
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            _buildHeader(context),
            const SizedBox(height: 12),
            Expanded(
              child: switch (_tab) {
                1 => const PapanTab(),
                2 => const KolaseTab(),
                _ => _buildPinTab(context),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinTab(BuildContext context) {
    final store = SavedStore.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BarisCariPin(),
        const SizedBox(height: 10),
        _buildChips(),
        const SizedBox(height: 10),
        Expanded(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              final pins = store.pins;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: MasonryGrid<Pin>(
                        items: pins,
                        columns: 3,
                        crossSpacing: 6,
                        mainSpacing: 6,
                        aspectOf: (p) => p.aspect,
                        itemBuilder: (context, p) => GestureDetector(
                          key: ValueKey('saved-${p.id}'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PinDetailScreen(pin: p),
                            ),
                          ),
                          onLongPress: () => _showRemoveSheet(context, p),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: p.aspect,
                              child: PinImage(p),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      AppStrings.pinsSaved(pins.length),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showRemoveSheet(BuildContext context, Pin pin) {
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
              leading: const Icon(Icons.bookmark_remove_outlined,
                  color: Colors.black),
              title: const Text(
                AppStrings.removeFromSaved,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                SavedStore.instance.remove(pin);
                Navigator.of(sheetContext).pop();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Menu pengaturan sederhana: Keluar -> kembali ke halaman awal (Welcome).
  void _showSettingsSheet(BuildContext context) {
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
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text(
                AppStrings.logout,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                await authRepository.keluar();
                tabIndex.value = 0;
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (_) => const WelcomePage()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 4),
        // Ketuk avatar -> halaman profil. Inisial ikut berubah saat nama diedit.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ProfilePage()),
          ),
          child: AnimatedBuilder(
            animation: ProfilStore.instance,
            builder: (context, _) => CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.avatarGreen,
              child: Text(
                ProfilStore.instance.saatIni.inisial,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        _tabItem(AppStrings.tabPins, 0),
        const SizedBox(width: 22),
        _tabItem(AppStrings.tabBoards, 1),
        const SizedBox(width: 22),
        _tabItem(AppStrings.tabCollages, 2),
        const Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showSettingsSheet(context),
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: Icon(Icons.settings_outlined, size: 28, color: Colors.black),
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _buildChips() {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.chipGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.apps, size: 20, color: Colors.black),
        ),
        const SizedBox(width: 6),
        const ChipSaved(label: AppStrings.favourites, ikon: Icons.star),
        const SizedBox(width: 6),
        const ChipSaved(label: AppStrings.createdByYou),
      ],
    );
  }

  Widget _tabItem(String label, int index) {
    final selected = _tab == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _tab = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Container(height: 2, width: selected ? 26 : 0, color: Colors.black),
        ],
      ),
    );
  }
}
