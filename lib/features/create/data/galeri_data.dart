import 'dart:typed_data';

/// Satu foto/video di galeri tiruan.
///
/// Galeri HP sungguhan belum dibaca; daftar ini hanya data contoh yang
/// gambarnya ada di assets/images/galeri/. Nanti bisa diganti paket
/// `photo_manager` / `image_picker` tanpa mengubah tampilan.
class GaleriItem {
  final String id;
  final String tanggal;
  final double aspect; // lebar / tinggi
  final String? durasi; // non-null = video

  /// Hasil kamera: isi foto (atau gambar sampul untuk video).
  final Uint8List? bytes;

  /// Hasil kamera: lokasi file video (di Web berupa alamat blob).
  final String? videoPath;

  const GaleriItem(
    this.id,
    this.tanggal, {
    this.aspect = 0.75,
    this.durasi,
    this.bytes,
    this.videoPath,
  });

  bool get video => durasi != null;
  bool get dariKamera => id.startsWith('kamera_');
  String get asset => 'assets/images/galeri/$id.jpg';
}

const List<GaleriItem> galeriItems = [
  // Hari Ini
  GaleriItem('foto_01', 'Hari Ini'),
  GaleriItem('foto_02', 'Hari Ini'),
  GaleriItem('foto_03', 'Hari Ini', aspect: 1.0),
  GaleriItem('foto_04', 'Hari Ini'),
  // 13 Okt
  GaleriItem('foto_05', '13 Okt'),
  GaleriItem('foto_06', '13 Okt', durasi: '0:17'),
  GaleriItem('foto_07', '13 Okt'),
  GaleriItem('foto_08', '13 Okt'),
  GaleriItem('foto_09', '13 Okt', aspect: 1.0),
  GaleriItem('foto_10', '13 Okt'),
  GaleriItem('foto_11', '13 Okt'),
  GaleriItem('foto_12', '13 Okt'),
  // 12 Okt
  GaleriItem('foto_13', '12 Okt'),
  GaleriItem('foto_14', '12 Okt'),
  GaleriItem('foto_15', '12 Okt', durasi: '0:08'),
  GaleriItem('foto_16', '12 Okt'),
  GaleriItem('foto_17', '12 Okt', aspect: 1.0),
  GaleriItem('foto_18', '12 Okt'),
  GaleriItem('foto_19', '12 Okt'),
  GaleriItem('foto_20', '12 Okt'),
  GaleriItem('foto_21', '12 Okt'),
  GaleriItem('foto_22', '12 Okt'),
  GaleriItem('foto_23', '12 Okt'),
  GaleriItem('foto_24', '12 Okt'),
];
