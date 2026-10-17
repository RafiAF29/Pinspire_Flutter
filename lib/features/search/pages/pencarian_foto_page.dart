import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/navigation/pindah_tab.dart';
import '../../../core/strings.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/masonry_grid.dart';
import '../../pin/models/pin.dart';
import '../../pin/widgets/pin_card.dart';
import '../data/search_repository.dart';

/// Hasil pencarian dari foto kamera: foto yang diambil di atas, lalu grid
/// "Ide serupa". Hasilnya masih contoh (belum ada pencarian visual sungguhan).
class PencarianFotoPage extends StatelessWidget {
  const PencarianFotoPage({super.key, required this.foto, this.aspek = 0.75});

  final Uint8List foto;
  final double aspek;

  @override
  Widget build(BuildContext context) {
    final List<Pin> pins = SearchRepository.instance.hasil('foto');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Icon(Icons.chevron_left, size: 30, color: Colors.black),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      AppStrings.visualSearchTitle,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AspectRatio(
                            aspectRatio: aspek,
                            child: Image.memory(foto, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        AppStrings.visualSearchSimilar,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                    ),
                    MasonryGrid<Pin>(
                      items: pins,
                      columns: 2,
                      crossSpacing: 6,
                      mainSpacing: 0,
                      extraRatio: 0.14,
                      aspectOf: (p) => p.aspect,
                      itemBuilder: (_, p) => PinCard(pin: p),
                    ),
                  ],
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
