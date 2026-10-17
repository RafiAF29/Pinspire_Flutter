import 'package:flutter/material.dart';

import '../../../core/navigation/tab_state.dart';
import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/masonry_grid.dart';
import '../../../core/widgets/pin_image.dart';
import '../../create/widgets/create_sheet.dart';
import '../../pin/data/like_store.dart';
import '../../pin/data/pin_repository.dart';
import '../../pin/data/saved_store.dart';
import '../../pin/models/pin.dart';
import '../../pin/widgets/pin_card.dart';
import '../widgets/hero_badge.dart';
import '../widgets/like_button.dart';
import '../widgets/save_button.dart';

/// Halaman detail pin.
///
/// Alur simpan:
/// 1. Belum disimpan  -> tombol "Simpan" (merah), tanpa bottom nav.
/// 2. Tap "Simpan"    -> tombol "Disimpan" (gelap) + bottom nav + thumbnail kecil.
/// 3. ~2 detik later  -> tombol otomatis jadi "Profil" (thumbnail hilang).
/// 4. Tap "Profil"    -> pindah ke tab Disimpan. Batal simpan hanya bisa dari sana.
class PinDetailScreen extends StatelessWidget {
  final Pin pin;
  const PinDetailScreen({super.key, required this.pin});

  @override
  Widget build(BuildContext context) {
    final saves = SavedStore.instance;
    final likes = LikeStore.instance;
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([saves, likes]),
        builder: (context, _) {
          final saved = saves.isSaved(pin);
          final justSaved = saves.isJustSaved(pin);
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: SafeArea(
                        bottom: false,
                        child: _buildContent(context, saves, likes),
                      ),
                    ),
                    // Thumbnail kecil hanya di fase "Disimpan"
                    if (justSaved)
                      Align(
                        alignment: const Alignment(0.6, 1),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: PinImage(pin),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Bottom nav muncul setelah pin disimpan
              if (saved)
                PinBottomNav(
                  index: tabIndex.value,
                  onTap: (i) {
                    final nav = Navigator.of(context);
                    nav.popUntil((r) => r.isFirst);
                    if (i == 2) {
                      // Buat: kembali ke Beranda lalu buka pilihan Pin/Kolase/Papan.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final ctx = nav.overlay?.context;
                        if (ctx != null && ctx.mounted) showCreateSheet(ctx);
                      });
                    } else {
                      tabIndex.value = i;
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SavedStore saves,
    LikeStore likes,
  ) {
    final related = PinRepository.instance.relatedPins(pin);
    final hasTitle = pin.title != null && pin.title!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroImage(context, likes),
        _buildActionRow(context, saves, likes),
        _buildAuthor(),
        if (hasTitle) _buildTitle(),
        if (pin.translatable) _buildTranslate(),
        const Padding(
          padding: EdgeInsets.fromLTRB(14, 12, 14, 6),
          child: Text(
            AppStrings.moreToExplore,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 16),
          child: MasonryGrid<Pin>(
            items: related,
            columns: 2,
            crossSpacing: 4,
            mainSpacing: 0,
            extraRatio: 0.14, // ruang untuk baris judul di PinCard
            aspectOf: (p) => p.aspect,
            itemBuilder: (_, p) => PinCard(pin: p, openDetail: false),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context, LikeStore likes) {
    final ratio = pin.aspect.clamp(0.75, 1.0).toDouble();
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: AspectRatio(aspectRatio: ratio, child: PinImage(pin)),
        ),
        Positioned(
          top: 6,
          left: 6,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.overlayWhite,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.chevron_left,
                  size: 30, color: Colors.black),
            ),
          ),
        ),
        // "Suka" (sebentar setelah di-like) atau "Dimodifikasi AI"
        HeroBadge(
          liked: likes.isLabelVisible(pin),
          aiModified: pin.aiModified,
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.image_search_outlined,
                size: 24, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    SavedStore saves,
    LikeStore likes,
  ) {
    final saved = saves.isSaved(pin);
    final justSaved = saves.isJustSaved(pin);

    final SaveButtonState buttonState;
    final VoidCallback? onButtonTap;
    if (!saved) {
      buttonState = SaveButtonState.save;
      onButtonTap = () => saves.save(pin);
    } else if (justSaved) {
      buttonState = SaveButtonState.saved;
      onButtonTap = null; // fase singkat, belum ada aksi
    } else {
      buttonState = SaveButtonState.profile;
      onButtonTap = () {
        tabIndex.value = 4; // tab Disimpan
        Navigator.of(context).popUntil((r) => r.isFirst);
      };
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 0),
      child: Row(
        children: [
          LikeButton(
            liked: likes.isLiked(pin),
            count: likes.likeCount(pin),
            onTap: () => likes.toggle(pin),
          ),
          const SizedBox(width: 18),
          const Icon(Icons.chat_bubble_outline, size: 24, color: Colors.black),
          if (pin.comments > 0) ...[
            const SizedBox(width: 6),
            Text(
              '${pin.comments}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
          const SizedBox(width: 18),
          const Icon(Icons.share_outlined, size: 24, color: Colors.black),
          const SizedBox(width: 14),
          const Icon(Icons.more_horiz, size: 28, color: Colors.black),
          const Spacer(),
          SaveButton(state: buttonState, onTap: onButtonTap),
        ],
      ),
    );
  }

  Widget _buildAuthor() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Row(
        children: [
          const CircleAvatar(radius: 7, backgroundColor: Color(0xFF6B6B5A)),
          const SizedBox(width: 6),
          Text(pin.author, style: const TextStyle(fontSize: 10.5)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              pin.title ?? '',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.chipGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.keyboard_arrow_down,
                size: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslate() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14, 6, 14, 0),
      child: Text(
        AppStrings.seeTranslation,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.hint,
        ),
      ),
    );
  }
}
