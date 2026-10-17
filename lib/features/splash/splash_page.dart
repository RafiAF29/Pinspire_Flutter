import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/widgets/pinspire_logo.dart';
import '../auth/pages/welcome_page.dart';

/// Layar pembuka: logo Pinspire di tengah, lalu pindah ke halaman awal.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2200), _lanjut);
  }

  void _lanjut() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const WelcomePage(),
        transitionsBuilder: (_, animasi, __, child) =>
            FadeTransition(opacity: animasi, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (context, nilai, child) => Opacity(
            opacity: nilai.clamp(0.0, 1.0),
            child: Transform.scale(scale: nilai, child: child),
          ),
          child: const PinspireLogo(ukuran: 96),
        ),
      ),
    );
  }
}
