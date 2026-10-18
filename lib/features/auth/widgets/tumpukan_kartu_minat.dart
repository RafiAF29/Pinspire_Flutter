import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/daftar_minat.dart';

/// Tumpukan 3 kartu foto pada layar loading "Pilihan yang bagus!".
///
/// Foto diambil dari minat yang dipilih pengguna. Selama loading, foto di
/// ketiga kartu bergantian: kartu belakang maju ke depan, kartu depan
/// digantikan foto berikutnya (fade + zoom halus).
class TumpukanKartuMinat extends StatefulWidget {
  const TumpukanKartuMinat({
    super.key,
    required this.gambar,
    this.jeda = const Duration(milliseconds: 850),
    this.durasiGanti = const Duration(milliseconds: 520),
  });

  /// Path asset foto. Boleh kurang dari 3 / kosong (otomatis dilengkapi).
  final List<String> gambar;

  /// Selang waktu antar pergantian foto.
  final Duration jeda;

  /// Lama animasi satu pergantian.
  final Duration durasiGanti;

  @override
  State<TumpukanKartuMinat> createState() => _TumpukanKartuMinatState();
}

class _TumpukanKartuMinatState extends State<TumpukanKartuMinat> {
  late final List<String> _daftar = _siapkan(widget.gambar);
  Timer? _timer;
  int _i = 0;

  /// Minimal 3 foto supaya tiga kartu selalu terisi dan selalu berbeda.
  static List<String> _siapkan(List<String> asal) {
    final hasil = <String>[...asal];
    for (final m in daftarMinat) {
      if (hasil.length >= 3) break;
      if (!hasil.contains(m.gambar)) hasil.add(m.gambar);
    }
    return hasil;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.jeda, (_) {
      if (!mounted) return;
      setState(() => _i = (_i + 1) % _daftar.length);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Muat semua foto lebih dulu agar pergantian tidak berkedip.
    for (final path in _daftar) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _foto(int geser) => _daftar[(_i + geser) % _daftar.length];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        // Ukuran kartu mengikuti ruang yang tersedia (rasio 3:4).
        final tinggi = math.min(box.maxHeight, 340.0);
        final lebarKartu = math.min(box.maxWidth * 0.58, (tinggi - 40) / 1.3);
        final tinggiKartu = lebarKartu * 1.3;

        Widget kartu(String path, {required int slot}) => _Kartu(
              key: ValueKey('slot$slot'),
              path: path,
              lebar: lebarKartu,
              tinggi: tinggiKartu,
              durasi: widget.durasiGanti,
            );

        return Center(
          child: SizedBox(
            width: box.maxWidth,
            height: tinggiKartu + 28,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Kartu belakang kiri.
                Transform.translate(
                  offset: Offset(-lebarKartu * 0.34, 14),
                  child: Transform.rotate(
                    angle: -0.10,
                    child: kartu(_foto(2), slot: 0),
                  ),
                ),
                // Kartu belakang kanan.
                Transform.translate(
                  offset: Offset(lebarKartu * 0.34, -8),
                  child: Transform.rotate(
                    angle: 0.09,
                    child: kartu(_foto(1), slot: 1),
                  ),
                ),
                // Kartu depan.
                Transform.rotate(
                  angle: -0.015,
                  child: kartu(_foto(0), slot: 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Satu kartu; saat [path] berubah fotonya berganti dengan fade + zoom.
class _Kartu extends StatelessWidget {
  const _Kartu({
    super.key,
    required this.path,
    required this.lebar,
    required this.tinggi,
    required this.durasi,
  });

  final String path;
  final double lebar;
  final double tinggi;
  final Duration durasi;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lebar,
      height: tinggi,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AnimatedSwitcher(
          duration: durasi,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animasi) => FadeTransition(
            opacity: animasi,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.08, end: 1.0).animate(animasi),
              child: child,
            ),
          ),
          layoutBuilder: (saatIni, sebelumnya) => Stack(
            fit: StackFit.expand,
            children: [...sebelumnya, ?saatIni],
          ),
          child: Image.asset(
            path,
            key: ValueKey(path),
            width: lebar,
            height: tinggi,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }
}
