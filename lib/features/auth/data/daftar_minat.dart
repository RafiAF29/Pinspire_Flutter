import 'package:flutter/material.dart';

/// Satu pilihan pada langkah "Apa yang sedang ingin Anda lakukan?".
class Minat {
  const Minat(this.label, this.gambar, this.warnaLatar);

  final String label;

  /// Lokasi gambar di folder assets.
  final String gambar;

  /// Warna kartu yang mengintip di belakang foto.
  final Color warnaLatar;
}

const List<Minat> daftarMinat = [
  Minat('Ruang kecil', 'assets/images/minat/ruang_kecil.jpg', Color(0xFF384958)),
  Minat('Memasak', 'assets/images/minat/memasak.jpg', Color(0xFF677291)),
  Minat('Lukisan', 'assets/images/minat/lukisan.jpg', Color(0xFF9AA0A6)),
  Minat('Inspirasi rambut', 'assets/images/minat/inspirasi_rambut.jpg', Color(0xFF9CB8CF)),
  Minat('Tren kuku', 'assets/images/minat/tren_kuku.jpg', Color(0xFF487695)),
  Minat('Kutipan', 'assets/images/minat/kutipan.jpg', Color(0xFFAF8DFC)),
  Minat('Ide kelas', 'assets/images/minat/ide_kelas.jpg', Color(0xFF385C7F)),
  Minat('Anime dan komik', 'assets/images/minat/anime_komik.jpg', Color(0xFFB4BECA)),
  Minat('Ide pesta', 'assets/images/minat/ide_pesta.jpg', Color(0xFF567B93)),
  Minat('Ide busana', 'assets/images/minat/ide_busana.jpg', Color(0xFF8D959E)),
  Minat('Dekorasi rumah', 'assets/images/minat/dekorasi_rumah.jpg', Color(0xFF35D075)),
  Minat('Renovasi rumah', 'assets/images/minat/renovasi_rumah.jpg', Color(0xFF416184)),
  Minat('Hewan lucu', 'assets/images/minat/hewan_lucu.jpg', Color(0xFF49D4C6)),
  Minat('Estetika', 'assets/images/minat/estetika.jpg', Color(0xFF7B8DA1)),
  Minat('Kustomisasi gim video', 'assets/images/minat/kustomisasi_gim.jpg', Color(0xFF30637E)),
];

/// Gambar milik minat yang dipilih pengguna (urutannya mengikuti [daftarMinat]).
/// Dipakai layar loading setelah masuk/daftar agar kartunya sesuai pilihan.
List<String> gambarMinatTerpilih(Iterable<String> labelTerpilih) {
  final pilih = labelTerpilih.toSet();
  return [
    for (final m in daftarMinat)
      if (pilih.contains(m.label)) m.gambar,
  ];
}
