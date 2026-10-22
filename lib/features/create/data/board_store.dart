import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/api_constants.dart';
import '../../pin/models/pin.dart';

class Board {
  final String id;
  final String name;
  final bool privat;
  final List<Pin> pins = [];

  /// Waktu papan dibuat (untuk teks "3 menit" di kartu papan).
  final DateTime dibuat;

  /// Waktu terakhir ada Pin masuk (null = belum ada).
  DateTime? terakhirDiubah;

  Board({
    required this.id,
    required this.name,
    required this.privat,
    DateTime? dibuat,
  }) : dibuat = dibuat ?? DateTime.now();

  /// Konstruktor dari JSON response REST API.
  factory Board.fromJson(Map<String, dynamic> json) {
    final board = Board(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      privat: json['is_private'] == true || json['is_private'] == 1,
      dibuat: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
    // Muat pins jika tersedia di response.
    if (json['pins'] != null && json['pins'] is List) {
      for (final p in json['pins'] as List) {
        board.pins.add(Pin.fromJson(p as Map<String, dynamic>));
      }
    }
    return board;
  }
}

/// Daftar papan buatan pengguna — sinkron dengan REST API.
class BoardStore extends ChangeNotifier {
  BoardStore._();
  static final BoardStore instance = BoardStore._();

  final List<Board> _boards = [];
  final List<Board> _dihapus = [];
  bool _loaded = false;

  List<Board> get boards => List.unmodifiable(_boards);

  /// Papan yang baru dihapus (bisa dipulihkan, hilang permanen setelah 7 hari).
  List<Board> get dihapus => List.unmodifiable(_dihapus);

  /// Semua Pin yang sudah dimasukkan ke salah satu papan.
  bool pinSudahDiPapan(Pin pin) =>
      _boards.any((b) => b.pins.any((e) => e.id == pin.id));

  // ───────────── Ambil data dari API ─────────────

  /// Muat daftar boards dari server (panggil sekali saat app dimulai).
  Future<void> muat() async {
    try {
      final token = await _getToken();
      if (token == null) return;
      final res = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/boards'),
        headers: ApiConstants.authHeaders(token),
      );
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        _boards.clear();
        for (final json in list) {
          _boards.add(Board.fromJson(json as Map<String, dynamic>));
        }
        _loaded = true;
        notifyListeners();
      }
    } catch (_) {
      // Gagal muat — pakai data lokal.
    }
  }

  bool get sudahDimuat => _loaded;

  // ───────────── CRUD ─────────────

  void hapus(Board papan) {
    if (!_boards.remove(papan)) return;
    _dihapus.insert(0, papan);
    notifyListeners();
    _apiHapus(papan.id);
  }

  /// Pulihkan semua papan yang baru dihapus.
  void pulihkan() {
    if (_dihapus.isEmpty) return;
    _boards.addAll(_dihapus);
    _dihapus.clear();
    notifyListeners();
    // Note: papan sudah dihapus di server; restore hanya lokal.
    // Untuk restore sungguhan perlu API soft-delete.
  }

  /// Buat papan baru via API, jika gagal tetap simpan lokal.
  Future<Board> buat(String nama, {required bool privat}) async {
    // Optimistic: buat lokal dulu.
    final sementara = Board(
      id: 'temp_${DateTime.now().microsecondsSinceEpoch}',
      name: nama,
      privat: privat,
    );
    _boards.insert(0, sementara);
    notifyListeners();

    // Kirim ke API.
    try {
      final token = await _getToken();
      if (token != null) {
        final res = await http.post(
          Uri.parse('${ApiConstants.baseUrl}/boards'),
          headers: ApiConstants.authHeaders(token),
          body: jsonEncode({
            'name': nama,
            'is_private': privat,
          }),
        );
        if (res.statusCode == 201 || res.statusCode == 200) {
          final json = jsonDecode(res.body) as Map<String, dynamic>;
          final papanBaru = Board.fromJson(json);
          // Ganti board sementara dengan board dari server.
          final idx = _boards.indexOf(sementara);
          if (idx >= 0) {
            _boards[idx] = papanBaru;
          }
          notifyListeners();
          return papanBaru;
        }
      }
    } catch (_) {
      // Gagal kirim ke server — tetap pakai data lokal.
    }
    return sementara;
  }

  /// Keluarkan Pin dari papan (Pin tetap ada di Disimpan).
  void hapusPin(Board papan, Pin pin) {
    papan.pins.removeWhere((e) => e.id == pin.id);
    notifyListeners();
    _apiHapusPin(papan.id, pin.id);
  }

  void tambahPin(Board papan, Pin pin) {
    papan.pins.insert(0, pin);
    papan.terakhirDiubah = DateTime.now();
    notifyListeners();
    _apiTambahPin(papan.id, pin.id);
  }

  // ───────────── REST API helpers ─────────────

  Future<void> _apiHapus(String boardId) async {
    try {
      final token = await _getToken();
      if (token == null) return;
      await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/boards/$boardId'),
        headers: ApiConstants.authHeaders(token),
      );
    } catch (_) {}
  }

  Future<void> _apiTambahPin(String boardId, String pinId) async {
    try {
      final token = await _getToken();
      if (token == null) return;
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}/boards/$boardId/pins/$pinId'),
        headers: ApiConstants.authHeaders(token),
      );
    } catch (_) {}
  }

  Future<void> _apiHapusPin(String boardId, String pinId) async {
    try {
      final token = await _getToken();
      if (token == null) return;
      await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/boards/$boardId/pins/$pinId'),
        headers: ApiConstants.authHeaders(token),
      );
    } catch (_) {}
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
