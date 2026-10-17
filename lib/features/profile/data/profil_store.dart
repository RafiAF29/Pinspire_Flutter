import 'package:flutter/foundation.dart';

import '../../auth/data/auth_repository.dart';

/// Data profil satu akun.
class DataProfil {
  DataProfil({
    required this.nama,
    required this.namaPengguna,
    this.bio = '',
    this.situs = '',
    this.tampilkanSemuaPin = true,
  });

  String nama;
  String namaPengguna;
  String bio;
  String situs;

  /// Tata letak: tampilkan kartu "Semua Pin" di profil.
  bool tampilkanSemuaPin;

  /// Belum ada fitur ikuti-mengikuti; selalu 0 seperti di desain.
  int pengikut = 0;
  int mengikuti = 0;

  String get inisial => nama.trim().isEmpty ? 'L' : nama.trim()[0].toUpperCase();
}

/// Profil akun yang sedang masuk (disimpan per email, di memori).
/// Nanti diganti API (GET/PATCH /me).
class ProfilStore extends ChangeNotifier {
  ProfilStore._();
  static final ProfilStore instance = ProfilStore._();

  final Map<String, DataProfil> _data = {};

  DataProfil get saatIni {
    final akun = authRepository.akunSaatIni;
    final kunci = akun?.email ?? '_tamu';
    return _data.putIfAbsent(
      kunci,
      () => DataProfil(
        nama: akun?.nama ?? 'Anda',
        namaPengguna: _usernameDari(akun?.nama ?? '', akun?.email ?? ''),
      ),
    );
  }

  static String _usernameDari(String nama, String email) {
    final dariNama = nama.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_.]'), '');
    if (dariNama.isNotEmpty) return dariNama;
    final dariEmail = email.split('@').first.toLowerCase();
    return dariEmail.isEmpty ? 'pengguna' : dariEmail;
  }

  void simpan({
    required String nama,
    required String namaPengguna,
    required String bio,
    required String situs,
    required bool tampilkanSemuaPin,
  }) {
    final d = saatIni;
    d.nama = nama.trim();
    d.namaPengguna = namaPengguna.trim();
    d.bio = bio.trim();
    d.situs = situs.trim();
    d.tampilkanSemuaPin = tampilkanSemuaPin;
    notifyListeners();
  }

  void ubahBio(String bio) {
    saatIni.bio = bio.trim();
    notifyListeners();
  }
}
