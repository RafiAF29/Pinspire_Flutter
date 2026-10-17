import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Ikon hati + jumlah like.
/// - Belum like: hati outline hitam.
/// - Sudah like: hati merah penuh dengan animasi "pop", angka naik dengan animasi geser.
class LikeButton extends StatefulWidget {
  final bool liked;
  final int count;
  final VoidCallback onTap;

  const LikeButton({
    super.key,
    required this.liked,
    required this.count,
    required this.onTap,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.4).chain(CurveTween(curve: Curves.easeOut)),
      weight: 40,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.4, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
      weight: 60,
    ),
  ]).animate(_controller);

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animasi pop hanya saat berubah dari belum like -> like.
    if (!oldWidget.liked && widget.liked) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: Icon(
                widget.liked ? Icons.favorite : Icons.favorite_border,
                size: 24,
                color: widget.liked ? AppColors.red : Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.6),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                '${widget.count}',
                key: ValueKey(widget.count),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
