import '../../auth/data/auth_repository.dart';

/// Mencatat akun mana yang sudah memilih "Allow all" untuk akses foto & video.
///
/// - Akun yang sudah "Allow all" tidak diminta izin lagi saat Buat Pin.
/// - "Allow limited access" hanya berlaku untuk sekali masuk (seperti Android),
///   jadi izin akan diminta lagi pada Buat Pin berikutnya.
/// - Data disimpan di memori (hilang saat aplikasi ditutup), sama seperti
///   MockAuthRepository. Nanti bisa disimpan ke API / penyimpanan lokal.
class GalleryAccessStore {
  GalleryAccessStore._();
  static final GalleryAccessStore instance = GalleryAccessStore._();

  final Set<String> _akunIzinSemua = {};
  final Set<String> _akunIzinKamera = {};
  final Set<String> _akunIzinAudio = {};

  String get _kunci => authRepository.akunSaatIni?.email ?? '_tamu';

  bool get sudahIzinkanSemua => _akunIzinSemua.contains(_kunci);

  void izinkanSemua() => _akunIzinSemua.add(_kunci);

  // ---- Kamera & audio (alur Buat Pin lewat kamera) ----
  // Hanya "While using the app" yang disimpan. "Only this time" tidak,
  // jadi izinnya ditanya lagi lain kali (sama seperti Android).

  bool get izinKamera => _akunIzinKamera.contains(_kunci);
  bool get izinAudio => _akunIzinAudio.contains(_kunci);

  /// Kedua izin sudah ada -> layar izin kamera dilewati.
  bool get izinKameraLengkap => izinKamera && izinAudio;

  void izinkanKamera() => _akunIzinKamera.add(_kunci);
  void izinkanAudio() => _akunIzinAudio.add(_kunci);

  /// Dipakai pada pengujian.
  void reset() {
    _akunIzinSemua.clear();
    _akunIzinKamera.clear();
    _akunIzinAudio.clear();
  }
}
