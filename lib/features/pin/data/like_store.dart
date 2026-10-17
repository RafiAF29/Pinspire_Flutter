import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/pin.dart';

/// State like per pin.
/// Nanti toggle() diganti panggilan API (POST/DELETE /pins/{id}/like).
class LikeStore extends ChangeNotifier {
  LikeStore._();
  static final LikeStore instance = LikeStore._();

  /// Berapa lama label "Suka" muncul di atas gambar setelah di-like.
  static const labelDuration = Duration(milliseconds: 1600);

  final Set<String> _liked = {};
  String? _labelPinId;
  Timer? _labelTimer;

  bool isLiked(Pin pin) => _liked.contains(pin.id);

  /// Jumlah like yang ditampilkan: 153 -> 154 kalau kamu like, balik lagi kalau unlike.
  int likeCount(Pin pin) => pin.likes + (isLiked(pin) ? 1 : 0);

  /// True sebentar setelah pin di-like (untuk label "Suka" di screenshot 2).
  bool isLabelVisible(Pin pin) => _labelPinId == pin.id;

  void toggle(Pin pin) {
    _labelTimer?.cancel();

    if (_liked.contains(pin.id)) {
      // Unlike: heart kembali kosong, count turun, label hilang.
      _liked.remove(pin.id);
      _labelPinId = null;
    } else {
      // Like: heart merah, count naik, label "Suka" muncul sebentar.
      _liked.add(pin.id);
      _labelPinId = pin.id;
      _labelTimer = Timer(labelDuration, () {
        _labelPinId = null;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _labelTimer?.cancel();
    super.dispose();
  }
}
