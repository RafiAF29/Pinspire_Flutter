import 'package:flutter/foundation.dart';

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
}

/// Daftar papan buatan pengguna.
/// Nanti diganti API (POST /boards, GET /boards).
class BoardStore extends ChangeNotifier {
  BoardStore._();
  static final BoardStore instance = BoardStore._();

  final List<Board> _boards = [];
  final List<Board> _dihapus = [];
  int _urut = 0;

  List<Board> get boards => List.unmodifiable(_boards);

  /// Papan yang baru dihapus (bisa dipulihkan, hilang permanen setelah 7 hari).
  List<Board> get dihapus => List.unmodifiable(_dihapus);

  /// Semua Pin yang sudah dimasukkan ke salah satu papan.
  bool pinSudahDiPapan(Pin pin) =>
      _boards.any((b) => b.pins.any((e) => e.id == pin.id));

  void hapus(Board papan) {
    if (!_boards.remove(papan)) return;
    _dihapus.insert(0, papan);
    notifyListeners();
  }

  /// Pulihkan semua papan yang baru dihapus.
  void pulihkan() {
    if (_dihapus.isEmpty) return;
    _boards.addAll(_dihapus);
    _dihapus.clear();
    notifyListeners();
  }

  Board buat(String nama, {required bool privat}) {
    final papan = Board(id: 'board_${_urut++}', name: nama, privat: privat);
    _boards.insert(0, papan);
    notifyListeners();
    return papan;
  }

  /// Keluarkan Pin dari papan (Pin tetap ada di Disimpan).
  void hapusPin(Board papan, Pin pin) {
    papan.pins.removeWhere((e) => e.id == pin.id);
    notifyListeners();
  }

  void tambahPin(Board papan, Pin pin) {
    papan.pins.insert(0, pin);
    papan.terakhirDiubah = DateTime.now();
    notifyListeners();
  }
}
