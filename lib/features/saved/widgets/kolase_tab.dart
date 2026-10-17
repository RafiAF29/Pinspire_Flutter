import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import 'bagian_saved.dart';

/// Disimpan > Kolase: belum ada kolase, tampil ajakan membuat kolase pertama.
class KolaseTab extends StatelessWidget {
  const KolaseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
          child: Row(
            children: [
              ChipSaved(label: AppStrings.createdByYou),
              SizedBox(width: 6),
              ChipSaved(label: AppStrings.inProgress),
              Spacer(),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(36, 0, 36, 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _IlustrasiKolase(),
                  const SizedBox(height: 22),
                  const Text(
                    AppStrings.createFirstCollage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.createFirstCollageDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, height: 1.3),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      AppStrings.createCollageBtn,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Lingkaran berisi potongan warna + gunting biru (ilustrasi kolase).
class _IlustrasiKolase extends StatelessWidget {
  const _IlustrasiKolase();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 124,
      height: 124,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: const [
                ColoredBox(color: Color(0xFFE9E4F6)),
                Positioned(
                  left: -10,
                  top: -10,
                  width: 80,
                  height: 60,
                  child: ColoredBox(color: Color(0xFF86B8E8)),
                ),
                Positioned(
                  left: 30,
                  top: 56,
                  width: 60,
                  height: 80,
                  child: ColoredBox(color: Color(0xFFF2A9C4)),
                ),
                Positioned(
                  right: -6,
                  bottom: -6,
                  width: 60,
                  height: 60,
                  child: ColoredBox(color: Color(0xFFFF6B3D)),
                ),
                Positioned(
                  left: 0,
                  bottom: 8,
                  width: 40,
                  height: 46,
                  child: ColoredBox(color: Color(0xFFE60023)),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 8,
            top: 0,
            child: Icon(Icons.content_cut, size: 52, color: Color(0xFF5B6CE0)),
          ),
        ],
      ),
    );
  }
}
