import '../models/data_registrasi.dart';

class AuthException implements Exception {
  const AuthException(this.pesan);

  final String pesan;

  @override
  String toString() => pesan;
}

/// Kontrak akses data autentikasi.
///
/// Saat ini dipakai [MockAuthRepository] (data disimpan di memori, hilang
/// saat aplikasi ditutup). Nanti, ketika API Laravel sudah siap, cukup buat
/// `ApiAuthRepository implements AuthRepository` yang memanggil REST API,
/// lalu ganti objek [authRepository] di bawah. Halaman UI tidak perlu diubah.
abstract class AuthRepository {
  AkunPengguna? get akunSaatIni;

  Future<bool> emailTerdaftar(String email);

  Future<AkunPengguna> masuk({
    required String email,
    required String kataSandi,
  });

  Future<AkunPengguna> daftar(DataRegistrasi data);

  Future<AkunPengguna> masukDenganGoogle(AkunGoogle akun);

  Future<void> keluar();
}

/// Ganti dengan `ApiAuthRepository()` saat backend Laravel sudah tersambung.
final AuthRepository authRepository = MockAuthRepository();

class _Catatan {
  const _Catatan({
    required this.nama,
    this.kataSandi,
    this.minat = const {},
  });

  final String nama;

  /// Minat yang dipilih saat mendaftar.
  final Set<String> minat;

  /// Null = akun dibuat lewat Google (tidak punya kata sandi).
  final String? kataSandi;
}

class MockAuthRepository implements AuthRepository {
  MockAuthRepository() {
    // Akun contoh untuk mencoba alur "Masuk".
    _basisData['demo@pinspire.com'] = const _Catatan(
      nama: 'Pengguna Demo',
      kataSandi: 'demo1234',
      minat: {'Hewan lucu', 'Memasak', 'Estetika', 'Dekorasi rumah'},
    );
  }

  final Map<String, _Catatan> _basisData = {};
  AkunPengguna? _akun;

  String _normal(String email) => email.trim().toLowerCase();

  Future<void> _tunda([int ms = 900]) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  @override
  AkunPengguna? get akunSaatIni => _akun;

  @override
  Future<bool> emailTerdaftar(String email) async {
    await _tunda(500);
    return _basisData.containsKey(_normal(email));
  }

  @override
  Future<AkunPengguna> masuk({
    required String email,
    required String kataSandi,
  }) async {
    await _tunda();
    final catatan = _basisData[_normal(email)];
    if (catatan == null) {
      throw const AuthException('Email ini belum terdaftar di Pinspire.');
    }
    if (catatan.kataSandi == null) {
      throw const AuthException(
          'Akun ini terdaftar lewat Google. Gunakan "Masuk dengan Google".');
    }
    if (catatan.kataSandi != kataSandi) {
      throw const AuthException(
          'Kata sandi salah. Coba lagi atau pilih "Lupa kata sandi?".');
    }
    return _akun = AkunPengguna(
      email: _normal(email),
      nama: catatan.nama,
      minat: catatan.minat,
    );
  }

  @override
  Future<AkunPengguna> daftar(DataRegistrasi data) async {
    await _tunda(400);
    final email = _normal(data.email);
    _basisData[email] = _Catatan(
      nama: data.nama,
      kataSandi: data.daftarDenganGoogle ? null : data.kataSandi,
      minat: Set<String>.of(data.minat),
    );
    return _akun = AkunPengguna(
      email: email,
      nama: data.nama,
      minat: Set<String>.of(data.minat),
    );
  }

  @override
  Future<AkunPengguna> masukDenganGoogle(AkunGoogle akun) async {
    await _tunda(400);
    final email = _normal(akun.email);
    final catatan = _basisData[email];
    return _akun = AkunPengguna(
      email: email,
      nama: catatan?.nama ?? akun.nama,
      minat: catatan?.minat ?? const {},
    );
  }

  @override
  Future<void> keluar() async {
    _akun = null;
  }
}
