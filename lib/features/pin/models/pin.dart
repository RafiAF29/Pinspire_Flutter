import 'dart:typed_data';

import 'package:flutter/material.dart';

class Pin {
  final String id;
  final String? title;
  final String image; // path asset (nanti bisa diganti URL dari API)
  final double aspect; // lebar / tinggi
  final Color fallback; // warna pengganti kalau gambar belum ada
  final String author;
  final int likes; // jumlah like awal dari server (belum termasuk like kamu)
  final int comments;
  final bool aiModified; // tampil label "Dimodifikasi AI" di gambar
  final bool translatable; // tampil "Lihat terjemahan" di bawah judul

  /// Isi gambar kalau pin dibuat dari kamera (menggantikan [image]).
  final Uint8List? bytes;

  const Pin({
    required this.id,
    required this.image,
    required this.aspect,
    required this.fallback,
    this.title,
    this.author = '· ᵗ- Fʟʏɪᴢᴡ̂ᵗ :ᵊ-',
    this.likes = 22,
    this.comments = 0,
    this.aiModified = false,
    this.translatable = false,
    this.bytes,
  });

  /// Konstruktor dari JSON response REST API.
  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      id: json['id'].toString(),
      title: json['title'] as String?,
      image: json['image_url'] as String? ?? '',
      aspect: double.tryParse(json['aspect'].toString()) ?? 1.0,
      fallback: const Color(0xFFD9D9D2),
      author: json['user']?['name'] as String? ?? 'Pinspire',
      likes: json['likes_count'] as int? ?? 0,
      comments: json['comments_count'] as int? ?? 0,
      aiModified: json['ai_modified'] == true || json['ai_modified'] == 1,
    );
  }
}
