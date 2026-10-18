import 'package:flutter/material.dart';

import '../../../core/strings.dart';

/// Label kecil di pojok kiri bawah gambar utama:
/// - "Suka" (hitam) muncul sebentar setelah pin di-like,
/// - kalau tidak, "Dimodifikasi AI" (transparan) untuk pin yang diedit AI,
/// - kalau tidak keduanya, kosong.
class HeroBadge extends StatelessWidget {
  final bool liked;
  final bool aiModified;
  const HeroBadge({super.key, required this.liked, required this.aiModified});

  @override
  Widget build(BuildContext context) {
    final Widget badge;
    if (liked) {
      badge = const _Pill(
        key: ValueKey('badge-like'),
        text: AppStrings.liked,
        color: Colors.black,
      );
    } else if (aiModified) {
      badge = const _Pill(
        key: ValueKey('badge-ai'),
        text: AppStrings.aiModified,
        color: Color(0x8C000000),
      );
    } else {
      badge = const SizedBox.shrink(key: ValueKey('badge-none'));
    }

    return Positioned(
      left: 10,
      bottom: 12,
      child: IgnorePointer(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.bottomLeft,
            children: [...previous, ?current],
          ),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: badge,
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
