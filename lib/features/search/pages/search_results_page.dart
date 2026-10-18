import 'package:flutter/material.dart';

import '../../../core/navigation/pindah_tab.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/masonry_grid.dart';
import '../../../core/strings.dart';
import '../../pin/models/pin.dart';
import '../../pin/widgets/pin_card.dart';
import '../data/search_repository.dart';
import 'search_input_page.dart';

/// Hasil pencarian: kolom pencarian + chip filter + grid Pin 2 kolom.
class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.query});

  final String query;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  bool _lebihSedikitAi = false;

  /// Ketuk kolom -> layar mengetik lagi; hasilnya menggantikan halaman ini.
  Future<void> _ubahPencarian() async {
    final q = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => SearchInputPage(awal: widget.query),
      ),
    );
    if (q == null || !mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => SearchResultsPage(query: q)),
    );
  }

  void _pilihChip(ChipHasil chip) {
    if (chip.label == AppStrings.lessAi) {
      setState(() => _lebihSedikitAi = !_lebihSedikitAi);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => SearchResultsPage(query: chip.label)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = SearchRepository.instance;
    final List<Pin> pins = repo.hasil(widget.query);
    final chips = repo.chip(widget.query);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 14, 0),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.chevron_left, size: 30, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _ubahPencarian,
                      child: Container(
                        height: 44,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Text(
                          widget.query,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.tune, size: 26, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: chips.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (context, i) => _ChipFilter(
                  chip: chips[i],
                  aktif: chips[i].label == AppStrings.lessAi && _lebihSedikitAi,
                  onTap: () => _pilihChip(chips[i]),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
                child: MasonryGrid<Pin>(
                  items: pins,
                  columns: 2,
                  crossSpacing: 6,
                  mainSpacing: 0,
                  extraRatio: 0.14,
                  aspectOf: (p) => p.aspect,
                  itemBuilder: (_, p) => PinCard(pin: p),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PinBottomNav(
        index: 1,
        onTap: (i) => pindahTab(context, i),
      ),
    );
  }
}

class _ChipFilter extends StatelessWidget {
  const _ChipFilter({
    required this.chip,
    required this.aktif,
    required this.onTap,
  });

  final ChipHasil chip;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bergambar = chip.gambar != null;
    final latar = aktif ? AppColors.dark : (chip.warna ?? AppColors.chipGrey);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 40,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: latar,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bergambar)
              SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  chip.gambar!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(color: Colors.white54),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: bergambar ? 10 : 14),
              child: Text(
                chip.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: aktif ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
