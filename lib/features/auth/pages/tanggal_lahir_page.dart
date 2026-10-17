import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/langkah_scaffold.dart';
import '../models/data_registrasi.dart';
import '../widgets/pemilih_tanggal_dialog.dart';
import 'jenis_kelamin_page.dart';

/// Langkah 4/7: "Hai {nama}! Masukkan tanggal lahir Anda".
/// Dialog roda pemilih tanggal terbuka otomatis saat halaman tampil.
class TanggalLahirPage extends StatefulWidget {
  const TanggalLahirPage({super.key, required this.data});

  final DataRegistrasi data;

  @override
  State<TanggalLahirPage> createState() => _TanggalLahirPageState();
}

class _TanggalLahirPageState extends State<TanggalLahirPage> {
  static const int _usiaMinimum = 16;

  DateTime? _tanggal;

  bool get _usiaCukup {
    final t = _tanggal;
    if (t == null) return false;
    final batas = DateTime.now();
    var usia = batas.year - t.year;
    final belumUlangTahun = batas.month < t.month ||
        (batas.month == t.month && batas.day < t.day);
    if (belumUlangTahun) usia--;
    return usia >= _usiaMinimum;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _pilihTanggal());
  }

  Future<void> _pilihTanggal() async {
    if (!mounted) return;
    final sekarang = DateTime.now();
    final hasil = await tampilkanPemilihTanggal(
      context,
      awal: _tanggal ?? DateTime(sekarang.year - 20, 1, 1),
      pertama: DateTime(sekarang.year - 100, 1, 1),
      terakhir: sekarang,
    );
    if (hasil != null && mounted) setState(() => _tanggal = hasil);
  }

  void _lanjut() {
    widget.data.tanggalLahir = _tanggal;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JenisKelaminPage(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tanggal = _tanggal;
    final kurangUmur = tanggal != null && !_usiaCukup;

    return LangkahScaffold(
      totalLangkah: widget.data.totalLangkah,
      langkahSaatIni: 4,
      judul: 'Hai ${widget.data.nama}! Masukkan tanggal lahir Anda',
      subjudul:
          'Agar Pinspire tetap aman, sekarang tanggal lahir wajib diisi. Tanggal lahir Anda juga membantu kami memberikan rekomendasi yang lebih dipersonalisasi dan iklan yang relevan. Kami tidak akan membagikan informasi ini tanpa izin Anda dan informasi ini tidak akan terlihat di profil Anda.',
      labelTombol: 'Berikutnya',
      onLanjut: _usiaCukup ? _lanjut : null,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 4),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _pilihTanggal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  tanggal == null ? 'Pilih tanggal' : formatTanggal(tanggal),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: tanggal == null ? AppColors.garis : AppColors.teks,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (kurangUmur)
              const Text(
                'Maaf, Anda harus berusia minimal 16 tahun untuk menggunakan Pinspire.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.merah),
              )
            else
              const Text(
                'Gunakan usia Anda sendiri, meskipun ini adalah akun bisnis',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.teksSekunder),
              ),
          ],
        ),
      ),
    );
  }
}
