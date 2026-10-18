/// Pengaturan global aplikasi Pinspire.
class AppConfig {
  AppConfig._();

  static const String namaAplikasi = 'Pinspire';

  /// Jika true, saat dijalankan di Web / Windows / Linux / macOS tampilan
  /// dibungkus bingkai HP Android (392 x 852). Di HP asli bingkai tidak muncul.
  /// Ubah ke false bila ingin tampilan layar penuh di laptop.
  static const bool bingkaiHpDiLaptop = true;

  /// Gambar di halaman Cari (slide besar & foto per bagian).
  /// Semua gambar minat sudah tersedia di assets/images/minat/.
  static const bool gambarHalamanCari = true;
}
