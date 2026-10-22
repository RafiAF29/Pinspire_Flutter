import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/api_constants.dart';
import '../models/pin.dart';

/// State pin yang disimpan — sinkron dengan REST API.
///
/// Alur tombol di halaman detail:
///   Simpan (merah)  --tap-->  Disimpan (gelap, [justSavedDuration])  --otomatis-->  Profil (gelap)
///
/// Tombol "Profil" membuka tab Disimpan. Batal simpan hanya bisa dari sana
/// lewat [remove].
class SavedStore extends ChangeNotifier {
  SavedStore._();
  static final SavedStore instance = SavedStore._();

  /// Berapa lama tombol menampilkan "Disimpan" sebelum berubah jadi "Profil".
  static const justSavedDuration = Duration(seconds: 2);

  final List<Pin> _pins = [];
  final List<Pin> _dibuat = [];
  DateTime? _terakhirDisimpan;
  String? _justSavedId;
  Timer? _timer;

  /// Urutan: yang terbaru disimpan ada di paling depan.
  List<Pin> get pins => List.unmodifiable(_pins);

  /// Pin buatan sendiri (tab "Dibuat" di profil), terbaru di depan.
  List<Pin> get dibuat => List.unmodifiable(_dibuat);

  /// Kapan terakhir ada Pin masuk ke Disimpan (null = belum pernah).
  DateTime? get terakhirDisimpan => _terakhirDisimpan;

  bool isSaved(Pin pin) => _pins.any((e) => e.id == pin.id);

  /// True hanya sebentar setelah pin baru disimpan (fase "Disimpan").
  bool isJustSaved(Pin pin) => _justSavedId == pin.id;

  void save(Pin pin) {
    if (isSaved(pin)) return;
    _pins.insert(0, pin);
    _terakhirDisimpan = DateTime.now();
    _justSavedId = pin.id;
    _timer?.cancel();
    _timer = Timer(justSavedDuration, () {
      _justSavedId = null;
      notifyListeners();
    });
    notifyListeners();
    _apiSave(pin.id);
  }

  /// Pin buatan sendiri yang sudah selesai diunggah ikut muncul di tab
  /// Disimpan, tanpa fase "Disimpan" di tombol.
  void tambahBuatan(Pin pin) {
    if (isSaved(pin)) return;
    _pins.insert(0, pin);
    _dibuat.insert(0, pin);
    _terakhirDisimpan = DateTime.now();
    notifyListeners();
  }

  void remove(Pin pin) {
    _pins.removeWhere((e) => e.id == pin.id);
    _dibuat.removeWhere((e) => e.id == pin.id);
    if (_justSavedId == pin.id) {
      _justSavedId = null;
      _timer?.cancel();
    }
    notifyListeners();
    _apiUnsave(pin.id);
  }

  // ----------- REST API -----------

  /// Kirim save ke REST API (fire-and-forget).
  Future<void> _apiSave(String pinId) async {
    try {
      final token = await _getToken();
      if (token == null) return;
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}/pins/$pinId/save'),
        headers: ApiConstants.authHeaders(token),
      );
    } catch (_) {}
  }

  /// Kirim unsave ke REST API (fire-and-forget).
  Future<void> _apiUnsave(String pinId) async {
    try {
      final token = await _getToken();
      if (token == null) return;
      await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/pins/$pinId/save'),
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
    _timer?.cancel();
    super.dispose();
  }
}
