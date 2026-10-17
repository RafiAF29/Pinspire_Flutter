enum JenisKelamin { wanita, pria, lainnya }

/// Data yang dikumpulkan sepanjang langkah registrasi.
/// Satu objek yang sama dioper dari halaman ke halaman.
class DataRegistrasi {
  DataRegistrasi({
    this.email = '',
    this.nama = '',
    this.daftarDenganGoogle = false,
  });

  String email;
  String kataSandi = '';
  String nama;
  DateTime? tanggalLahir;
  JenisKelamin? jenisKelamin;
  String negara = 'Indonesia';
  final Set<String> minat = {};

  /// true = alur registrasi lewat akun Google (3 langkah, tanpa sandi/nama/tanggal lahir).
  final bool daftarDenganGoogle;

  /// Jumlah titik indikator pada alur ini.
  int get totalLangkah => daftarDenganGoogle ? 3 : 7;
}

/// Akun Google yang ditampilkan di dialog "Pilih akun".
class AkunGoogle {
  const AkunGoogle({required this.nama, required this.email});

  final String nama;
  final String email;
}

/// Pengguna yang sedang masuk.
class AkunPengguna {
  const AkunPengguna({
    required this.email,
    required this.nama,
    this.minat = const {},
  });

  final String email;
  final String nama;

  /// Minat yang dipilih saat mendaftar (dipakai layar loading setelah masuk).
  final Set<String> minat;
}
