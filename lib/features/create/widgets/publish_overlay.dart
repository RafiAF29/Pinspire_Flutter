import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../data/publish_store.dart';

/// Ditaruh tepat di atas bottom nav Beranda:
/// - saat mengunggah: bar "Menyelesaikan ..." + garis merah di atasnya,
/// - setelah selesai: toast "Diterbitkan! Ingin berbagi?".
class PublishOverlay extends StatelessWidget {
  const PublishOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final store = PublishStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        switch (store.fase) {
          case PublishFase.diam:
            return const SizedBox.shrink();
          case PublishFase.mengunggah:
            return _Bar(progres: store.progres, onBatal: store.batal);
          case PublishFase.terbit:
            return _Toast(gambar: store.pin?.image, bytes: store.pin?.bytes);
        }
      },
    );
  }
}

class _Bar extends StatelessWidget {
  final double progres;
  final VoidCallback onBatal;
  const _Bar({required this.progres, required this.onBatal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.navBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: progres.clamp(0.0, 1.0),
            minHeight: 2,
            color: AppColors.red,
            backgroundColor: const Color(0xFFF3C6CB),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.chipGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    AppStrings.finishing,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBatal,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 22, color: Colors.black),
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

class _Toast extends StatelessWidget {
  final String? gambar;
  final Uint8List? bytes;
  const _Toast({required this.gambar, this.bytes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
          decoration: BoxDecoration(
            color: const Color(0xE6403F3B),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: bytes != null
                      ? Image.memory(bytes!, fit: BoxFit.cover)
                      : gambar == null
                      ? const ColoredBox(color: AppColors.chipGrey)
                      : Image.asset(
                          gambar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const ColoredBox(color: AppColors.chipGrey),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                AppStrings.published,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF25D366),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.call, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share, size: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
