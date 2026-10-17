import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../pin/models/pin.dart';

/// Satu slide besar di bagian atas halaman Cari.
class SlideJelajah {
  const SlideJelajah(this.label, this.judul, this.gambar);

  final String label;
  final String judul;
  final String gambar;
}

/// Satu bagian "Ide-ide buat Anda" / "Populer di Pinterest" (4 foto berjajar).
class BagianJelajah {
  const BagianJelajah(this.label, this.judul, this.gambar);

  final String label;
  final String judul;

  /// Tepat 4 foto.
  final List<String> gambar;
}

/// Chip filter di atas hasil pencarian.
class ChipHasil {
  const ChipHasil(this.label, {this.gambar, this.warna});

  final String label;
  final String? gambar;
  final Color? warna;
}

/// Sumber data halaman Cari. Sekarang masih dummy.
/// Nanti isi method-method ini diganti panggilan REST API
/// (mis. GET /search/explore, GET /search/suggest?q=, GET /search/pins?q=).
///
/// Foto sementara memakai gambar di assets/images/minat/ (satu-satunya foto
/// asli di proyek). Ganti path di bawah kalau sudah punya foto sendiri.
class SearchRepository {
  SearchRepository._();
  static final SearchRepository instance = SearchRepository._();

  static const String _dir = 'assets/images/minat/';
  static const String _anime = '${_dir}anime_komik.jpg';
  static const String _dekor = '${_dir}dekorasi_rumah.jpg';
  static const String _estetika = '${_dir}estetika.jpg';
  static const String _hewan = '${_dir}hewan_lucu.jpg';
  static const String _busana = '${_dir}ide_busana.jpg';
  static const String _kelas = '${_dir}ide_kelas.jpg';
  static const String _pesta = '${_dir}ide_pesta.jpg';
  static const String _rambut = '${_dir}inspirasi_rambut.jpg';
  static const String _gim = '${_dir}kustomisasi_gim.jpg';
  static const String _kutipan = '${_dir}kutipan.jpg';
  static const String _lukisan = '${_dir}lukisan.jpg';
  static const String _masak = '${_dir}memasak.jpg';
  static const String _renovasi = '${_dir}renovasi_rumah.jpg';
  static const String _ruang = '${_dir}ruang_kecil.jpg';
  static const String _kuku = '${_dir}tren_kuku.jpg';

  // ---------------------------------------------------------------------------
  // Halaman Cari (jelajah)
  // ---------------------------------------------------------------------------

  /// Slide besar di atas (7 titik indikator).
  final List<SlideJelajah> slide = const [
    SlideJelajah('Before the burn', 'Pre-workout fuel', _masak),
    SlideJelajah('Sedang tren', 'Kamar impian', _renovasi),
    SlideJelajah('Untuk Anda', 'Hewan menggemaskan', _hewan),
    SlideJelajah('Ide hari ini', 'Tren kuku terbaru', _kuku),
    SlideJelajah('Gaya hari ini', 'Inspirasi busana', _busana),
    SlideJelajah('Kembali ke sekolah', 'Ide kelas kreatif', _kelas),
    SlideJelajah('Dunia anime', 'Karakter favorit', _anime),
  ];

  final List<BagianJelajah> bagian = const [
    BagianJelajah(AppStrings.ideasForYou, 'Gambar profil',
        [_anime, _gim, _hewan, _rambut]),
    BagianJelajah(AppStrings.ideasForYou, 'Binatang lucu',
        [_hewan, _gim, _anime, _hewan]),
    BagianJelajah(AppStrings.ideasForYou, 'Sketsa gambar mudah',
        [_lukisan, _kutipan, _lukisan, _anime]),
    BagianJelajah(AppStrings.popularOnPinterest, 'Pp wa',
        [_gim, _estetika, _rambut, _lukisan]),
    BagianJelajah(AppStrings.popularOnPinterest, 'Wallpaper laptop',
        [_rambut, _estetika, _dekor, _kuku]),
    BagianJelajah(AppStrings.popularOnPinterest, 'Background pink',
        [_busana, _kuku, _gim, _pesta]),
    BagianJelajah(AppStrings.popularOnPinterest, 'Stiker wa',
        [_anime, _gim, _kutipan, _hewan]),
    BagianJelajah(AppStrings.popularOnPinterest, 'Sorotan ig',
        [_estetika, _ruang, _rambut, _kelas]),
  ];

  // ---------------------------------------------------------------------------
  // Saran pencarian (saat mengetik)
  // ---------------------------------------------------------------------------

  static const Map<String, List<String>> _saranKhusus = {
    'puppy': [
      'puppy',
      'puppy girl',
      'puppy boy',
      'puppy aesthetic',
      'puppy drawing',
      'puppy chow',
      'puppy cute',
      'puppy pfp',
    ],
  };

  static const List<String> _akhiran = [
    '',
    ' girl',
    ' boy',
    ' aesthetic',
    ' drawing',
    ' cute',
    ' wallpaper',
    ' pfp',
  ];

  /// Saran untuk teks yang sedang diketik. Item pertama = teks itu sendiri.
  List<String> saran(String input) {
    final q = input.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final khusus = _saranKhusus[q];
    if (khusus != null) return khusus;
    return [for (final a in _akhiran) '$q$a'];
  }

  // ---------------------------------------------------------------------------
  // Hasil pencarian
  // ---------------------------------------------------------------------------

  // (gambar, rasio lebar/tinggi, judul)
  static const List<(String, double, String?)> _kolam = [
    (_hewan, 0.78, 'Funny Dog Selfie Wallpap...'),
    (_gim, 0.72, null),
    (_hewan, 0.66, null),
    (_estetika, 0.80, 'Aesthetic photo ideas'),
    (_rambut, 0.75, null),
    (_masak, 1.0, 'Ramen rumahan'),
    (_dekor, 0.70, null),
    (_busana, 0.62, 'Outfit inspo'),
    (_anime, 1.15, null),
    (_kuku, 0.85, 'Nail art simple'),
    (_ruang, 0.74, null),
    (_lukisan, 0.90, 'Sketsa mudah'),
    (_pesta, 0.68, null),
    (_kutipan, 0.78, 'Kata-kata hari ini'),
    (_renovasi, 1.0, null),
    (_kelas, 0.82, null),
  ];

  static const List<String> _kataHewan = [
    'puppy', 'dog', 'cat', 'kitten', 'kucing', 'anjing', 'hewan', 'binatang',
    'animal', 'cute', 'lucu',
  ];

  bool _tentangHewan(String q) => _kataHewan.any((k) => q.contains(k));

  /// Pin hasil pencarian (selalu ada isinya). Urutan bergantung pada kata
  /// kunci supaya pencarian berbeda terasa berbeda.
  List<Pin> hasil(String input) {
    final q = input.trim().toLowerCase();

    var geser = q.codeUnits.fold<int>(0, (a, c) => (a * 31 + c) & 0xFFFF);
    geser %= _kolam.length;
    if (_tentangHewan(q)) geser = 0; // foto hewan paling depan.

    return [
      for (var n = 0; n < _kolam.length; n++) _pin((n + geser) % _kolam.length),
    ];
  }

  Pin _pin(int i) {
    final (gambar, rasio, judul) = _kolam[i];
    return Pin(
      id: 'cari_$i',
      title: judul,
      image: gambar,
      aspect: rasio,
      fallback: const Color(0xFFD9D9D2),
      author: 'Pinspire',
      likes: 12 + i * 7,
    );
  }

  /// Chip di atas hasil: "Lebih Sedikit AI" + kata kunci terkait.
  List<ChipHasil> chip(String input) {
    final q = input.trim().toLowerCase();
    if (_tentangHewan(q)) {
      return const [
        ChipHasil(AppStrings.lessAi),
        ChipHasil('Golden retriever', gambar: _hewan, warna: Color(0xFFFBD3F5)),
        ChipHasil('Drawing', gambar: _lukisan, warna: Color(0xFFD5DBFB)),
        ChipHasil('Wallpaper', gambar: _gim, warna: Color(0xFFD3F0E2)),
      ];
    }
    return [
      const ChipHasil(AppStrings.lessAi),
      ChipHasil('$q aesthetic',
          gambar: _estetika, warna: const Color(0xFFFBD3F5)),
      ChipHasil('$q wallpaper',
          gambar: _rambut, warna: const Color(0xFFD5DBFB)),
      ChipHasil('$q drawing',
          gambar: _lukisan, warna: const Color(0xFFD3F0E2)),
    ];
  }
}
