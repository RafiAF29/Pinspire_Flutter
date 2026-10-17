import 'package:flutter/material.dart';

import '../models/pin.dart';

/// Sumber data pin. Sekarang masih dummy.
/// Nanti isi method-method ini diganti panggilan REST API
/// (mis. GET /pins/feed, GET /pins/{id}/related).
///
/// Gambar diletakkan di assets/images/ (nama file ada di tiap Pin).
/// Kalau file belum ada, tampil kotak berwarna sebagai pengganti.
class PinRepository {
  PinRepository._();
  static final PinRepository instance = PinRepository._();

  // ---------------------------------------------------------------------------
  // Pin utama
  // ---------------------------------------------------------------------------

  static const dogPin = Pin(
    id: 'dog',
    title: "Sηʌкэ Ɛɣɜ'ȿ 猫影",
    image: 'assets/images/dog.jpg',
    aspect: 1.0,
    fallback: Color(0xFF9E9E9E),
    likes: 153,
    comments: 3,
  );

  /// Kucing + topi biru (277 like, 7 komentar, tanpa judul, label "Dimodifikasi AI").
  static const catCapPin = Pin(
    id: 'cat_cap',
    image: 'assets/images/cat_cap.jpg',
    aspect: 1.0,
    fallback: Color(0xFFD9B99B),
    author: 'authu',
    likes: 277,
    comments: 7,
    aiModified: true,
  );

  /// Beruang kutub + uang (judul bahasa Rusia -> ada "Lihat terjemahan").
  static const bearPin = Pin(
    id: 'bear',
    title: 'богатый медведь',
    image: 'assets/images/bear_money.jpg',
    aspect: 1.0,
    fallback: Color(0xFFB8B8C4),
    author: 'Evelyn',
    likes: 19,
    aiModified: true,
    translatable: true,
  );

  static const laCatPin = Pin(
    id: 'la_cat',
    image: 'assets/images/la_cat.jpg',
    aspect: 1.0,
    fallback: Color(0xFF3A3A3A),
  );

  static const puppyPin = Pin(
    id: 'puppy',
    image: 'assets/images/mlb_puppy.jpg',
    aspect: 1.0,
    fallback: Color(0xFF8A8A8A),
  );

  // ---------------------------------------------------------------------------
  // Feed Home
  // ---------------------------------------------------------------------------

  /// Kolom kiri feed Home.
  List<Pin> homeLeftColumn() => const [
        dogPin,
        Pin(
          id: 'music',
          title: 'Dark Music Player Photo T...',
          image: 'assets/images/feed_music.jpg',
          aspect: 0.56,
          fallback: Color(0xFF2B2B2B),
        ),
        Pin(
          id: 'routine',
          image: 'assets/images/feed_routine.jpg',
          aspect: 0.62,
          fallback: Color(0xFF111111),
        ),
        catCapPin,
        puppyPin,
      ];

  /// Kolom kanan feed Home.
  List<Pin> homeRightColumn() => const [
        Pin(
          id: 'bow',
          title: '1007',
          image: 'assets/images/feed_bow.jpg',
          aspect: 2.4,
          fallback: Color(0xFFC9808A),
        ),
        Pin(
          id: 'blue',
          title: "follow me women's and a...",
          image: 'assets/images/feed_blue.jpg',
          aspect: 0.57,
          fallback: Color(0xFF0D2A57),
        ),
        Pin(
          id: 'addphoto',
          image: 'assets/images/feed_addphoto.jpg',
          aspect: 0.75,
          fallback: Color(0xFFE9D3C9),
        ),
        bearPin,
        laCatPin,
      ];

  // ---------------------------------------------------------------------------
  // "Lainnya untuk dijelajahi"
  // ---------------------------------------------------------------------------

  static const _kitty = Pin(
    id: 'rel_kitty',
    title: 'cute kitty 😍✨',
    image: 'assets/images/rel_kitty.jpg',
    aspect: 1.0,
    fallback: Color(0xFF6E6A66),
  );
  static const _capCat = Pin(
    id: 'rel_cap_cat',
    title: 'Şapkalı tatlı kedi',
    image: 'assets/images/rel_cap_cat.jpg',
    aspect: 0.77,
    fallback: Color(0xFFCFC9C2),
  );
  static const _jerry = Pin(
    id: 'rel_jerry',
    image: 'assets/images/jerry.jpg',
    aspect: 1.0,
    fallback: Color(0xFF2A2420),
  );
  static const _cat1 = Pin(id: 'cat1', image: 'assets/images/cat1.jpg', aspect: 1.0, fallback: Color(0xFF555555));
  static const _cat2 = Pin(id: 'cat2', image: 'assets/images/cat2.jpg', aspect: 1.0, fallback: Color(0xFF777777));
  static const _cat3 = Pin(id: 'cat3', image: 'assets/images/cat3.jpg', aspect: 1.0, fallback: Color(0xFF666666));
  static const _cat4 = Pin(id: 'cat4', image: 'assets/images/cat4.jpg', aspect: 1.0, fallback: Color(0xFF888888));

  /// Grid "Lainnya untuk dijelajahi" di halaman detail (beda tiap pin).
  List<Pin> relatedPins(Pin pin) {
    switch (pin.id) {
      case 'cat_cap':
        return const [_kitty, _capCat, _cat1, _cat2];
      case 'bear':
        return const [laCatPin, _jerry, _cat3, _cat4];
      default:
        return const [_cat1, _cat2, _cat3, _cat4];
    }
  }
}
