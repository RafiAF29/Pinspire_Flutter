import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

/// Mengizinkan geser dengan mouse (di laptop/web) selain sentuhan,
/// supaya roda pemilih tanggal dan daftar bisa di-drag saat demo di laptop.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}
