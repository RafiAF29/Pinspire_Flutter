import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// Membungkus aplikasi dengan bingkai HP Android saat dijalankan di
/// laptop (Web / Windows / Linux / macOS), sehingga tampilannya selalu
/// seperti layar HP. Di HP/emulator Android asli bingkai ini tidak dipakai.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  /// Ukuran layar HP (dp) yang disimulasikan.
  static const Size ukuranHp = Size(392, 852);
  static const double _tinggiStatusBar = 30;
  static const double _tinggiNavBar = 18;
  static const double _tebalBezel = 8;

  bool get _perluBingkai {
    if (!AppConfig.bingkaiHpDiLaptop) return false;
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_perluBingkai) return child;

    final mq = MediaQuery.of(context);
    const padding = EdgeInsets.only(top: _tinggiStatusBar, bottom: _tinggiNavBar);

    return Material(
      color: const Color(0xFFE6E6E6),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              width: ukuranHp.width + _tebalBezel * 2,
              height: ukuranHp.height + _tebalBezel * 2,
              padding: const EdgeInsets.all(_tebalBezel),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(44),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: MediaQuery(
                  data: mq.copyWith(
                    size: ukuranHp,
                    padding: padding,
                    viewPadding: padding,
                    viewInsets: EdgeInsets.zero,
                  ),
                  child: ColoredBox(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Positioned.fill(child: child),
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: _tinggiStatusBar,
                          child: IgnorePointer(child: _StatusBarPalsu()),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Center(
                              child: Container(
                                width: 120,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0x55000000),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Status bar tiruan (jam, sinyal, baterai) agar terasa seperti HP.
class _StatusBarPalsu extends StatelessWidget {
  const _StatusBarPalsu();

  @override
  Widget build(BuildContext context) {
    final sekarang = DateTime.now();
    final jam = sekarang.hour.toString().padLeft(2, '0');
    final menit = sekarang.minute.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            '$jam.$menit',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
              decoration: TextDecoration.none,
            ),
          ),
          const Spacer(),
          const Icon(Icons.wifi, size: 14, color: Color(0xFF111111)),
          const SizedBox(width: 4),
          const Icon(Icons.signal_cellular_alt, size: 14, color: Color(0xFF111111)),
          const SizedBox(width: 4),
          const Icon(Icons.battery_full, size: 14, color: Color(0xFF111111)),
        ],
      ),
    );
  }
}
