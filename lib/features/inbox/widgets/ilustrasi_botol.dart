import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Ilustrasi "botol berisi surat" untuk kondisi kosong di bagian Pembaruan.
/// Digambar dengan CustomPaint supaya tidak butuh file gambar tambahan.
class IlustrasiBotol extends StatelessWidget {
  const IlustrasiBotol({super.key, this.ukuran = 140});

  final double ukuran;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ukuran,
      height: ukuran,
      child: CustomPaint(painter: _BotolPainter()),
    );
  }
}

class _BotolPainter extends CustomPainter {
  static const Color _lingkaran = Color(0xFFC8DCF2);
  static const Color _kaca = Color(0xFFE6EFFA);
  static const Color _kacaGelap = Color(0xFFD3E2F4);
  static const Color _biruTua = Color(0xFF2A3F8F);
  static const Color _biru = Color(0xFF2E7BE6);
  static const Color _pink = Color(0xFFF6B5C4);
  static const Color _merah = Color(0xFFE0102B);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final c = Offset(s / 2, s / 2);

    // Lingkaran latar.
    canvas.drawCircle(c, s * 0.5, Paint()..color = _lingkaran);

    canvas.save();
    // Botol dimiringkan 45 derajat, leher mengarah ke kanan atas.
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.pi / 4);

    final badan = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(0, s * 0.06),
        width: s * 0.36,
        height: s * 0.62,
      ),
      Radius.circular(s * 0.1),
    );
    final leher = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(0, -s * 0.31),
        width: s * 0.15,
        height: s * 0.2,
      ),
      Radius.circular(s * 0.03),
    );

    canvas.drawRRect(badan, Paint()..color = _kaca);
    canvas.drawRRect(leher, Paint()..color = _kaca);

    // Sisi bawah botol lebih gelap supaya terlihat bervolume.
    canvas.save();
    canvas.clipRRect(badan);
    canvas.drawRect(
      Rect.fromLTWH(-s * 0.18, s * 0.06, s * 0.36, s * 0.4),
      Paint()..color = _kacaGelap,
    );
    canvas.restore();

    // Gabus merah.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -s * 0.43),
          width: s * 0.13,
          height: s * 0.08,
        ),
        Radius.circular(s * 0.015),
      ),
      Paint()..color = _merah,
    );

    // Gulungan surat di dalam botol.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(-s * 0.03, -s * 0.02),
          width: s * 0.2,
          height: s * 0.3,
        ),
        Radius.circular(s * 0.02),
      ),
      Paint()..color = _biruTua,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(s * 0.03, s * 0.02),
          width: s * 0.17,
          height: s * 0.26,
        ),
        Radius.circular(s * 0.02),
      ),
      Paint()..color = _biru,
    );

    // Pita pink + label merah.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, s * 0.12),
          width: s * 0.3,
          height: s * 0.07,
        ),
        Radius.circular(s * 0.02),
      ),
      Paint()..color = _pink,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(0, s * 0.12),
        width: s * 0.045,
        height: s * 0.07,
      ),
      Paint()..color = _merah,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
