import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Logo "G" Google digambar dengan CustomPainter (tanpa file gambar).
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.ukuran = 22});

  final double ukuran;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ukuran,
      height: ukuran,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  static const _biru = Color(0xFF4285F4);
  static const _hijau = Color(0xFF34A853);
  static const _kuning = Color(0xFFFBBC05);
  static const _merah = Color(0xFFEA4335);

  double _rad(double derajat) => derajat * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final tebal = s * 0.2;
    final jari = s / 2 - tebal / 2;
    final pusat = Offset(s / 2, s / 2);
    final kotak = Rect.fromCircle(center: pusat, radius: jari);

    Paint kuas(Color warna) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = tebal
      ..color = warna
      ..isAntiAlias = true;

    // Sudut dihitung searah jarum jam dari arah jam 3.
    canvas.drawArc(kotak, _rad(-146), _rad(102), false, kuas(_merah));
    canvas.drawArc(kotak, _rad(134), _rad(82), false, kuas(_kuning));
    canvas.drawArc(kotak, _rad(48), _rad(88), false, kuas(_hijau));
    canvas.drawArc(kotak, _rad(-1), _rad(50), false, kuas(_biru));

    // Garis tengah huruf G.
    canvas.drawRect(
      Rect.fromLTRB(s * 0.5, s * 0.5 - tebal / 2, s, s * 0.5 + tebal / 2),
      Paint()..color = _biru,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
