import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/api_constants.dart';
import '../models/pin.dart';

/// State like per pin — sinkron dengan REST API.
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
      _apiUnlike(pin.id);
    } else {
      // Like: heart merah, count naik, label "Suka" muncul sebentar.
      _liked.add(pin.id);
      _labelPinId = pin.id;
      _labelTimer = Timer(labelDuration, () {
        _labelPinId = null;
        notifyListeners();
      });
      _apiLike(pin.id);
    }
    notifyListeners();
  }

  /// Kirim like ke REST API (fire-and-forget).
  Future<void> _apiLike(String pinId) async {
    try {
      final token = await _getToken();
      if (token == null) return;
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}/pins/$pinId/like'),
        headers: ApiConstants.authHeaders(token),
      );
    } catch (_) {
      // Gagal kirim ke server — state lokal tetap jalan.
    }
  }

  /// Kirim unlike ke REST API (fire-and-forget).
  Future<void> _apiUnlike(String pinId) async {
    try {
      final token = await _getToken();
      if (token == null) return;
      await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/pins/$pinId/like'),
        headers: ApiConstants.authHeaders(token),
      );
    } catch (_) {}
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void dispose() {
    _labelTimer?.cancel();
    super.dispose();
  }
}
