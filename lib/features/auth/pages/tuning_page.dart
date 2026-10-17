import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pinspire_logo.dart';
import '../../shell/main_shell.dart';
import '../data/auth_repository.dart';
import '../data/daftar_minat.dart';
import '../models/data_registrasi.dart';
import '../widgets/tumpukan_kartu_minat.dart';
import 'welcome_page.dart';

/// Layar loading "Pilihan yang bagus!" sebelum masuk ke Beranda.
///
/// Dipakai di dua alur:
/// - [TuningPage.registrasi] : setelah memilih minat; akun dibuat di sini.
/// - [TuningPage.masuk]      : setelah login (email/sandi atau Google).
///
/// Kartu di tengah layar memakai foto dari minat yang dipilih pengguna dan
/// bergantian selama loading ([TumpukanKartuMinat]).
class TuningPage extends StatefulWidget {
  const TuningPage._({
    super.key,
    required this.minat,
    required this.judul,
    this.tugas,
  });

  /// Alur daftar: simpan akun baru lalu masuk.
  factory TuningPage.registrasi({Key? key, required DataRegistrasi data}) {
    return TuningPage._(
      key: key,
      minat: Set<String>.of(data.minat),
      judul: data.daftarDenganGoogle
          ? _judulMenyesuaikan
          : 'Pilihan yang bagus!',
      tugas: () => authRepository.daftar(data),
    );
  }

  /// Alur login: akun sudah masuk, tinggal menyiapkan beranda.
  factory TuningPage.masuk({Key? key, required AkunPengguna akun}) {
    return TuningPage._(
      key: key,
      minat: Set<String>.of(akun.minat),
      judul: _judulMenyesuaikan,
    );
  }

  static const String _judulMenyesuaikan =
      'Menyesuaikan beranda Anda, khusus untuk Anda!';

  /// Label minat yang dipilih; menentukan foto pada kartu.
  final Set<String> minat;
  final String judul;

  /// Pekerjaan yang dijalankan selama loading (null = tidak ada).
  final Future<Object?> Function()? tugas;

  @override
  State<TuningPage> createState() => _TuningPageState();
}

class _TuningPageState extends State<TuningPage>
    with SingleTickerProviderStateMixin {
  static const Duration _lamaLoading = Duration(milliseconds: 3400);

  late final AnimationController _progres = AnimationController(
    vsync: this,
    duration: _lamaLoading,
  );

  @override
  void initState() {
    super.initState();
    _progres.forward();
    _selesai();
  }

  Future<void> _selesai() async {
    try {
      // Jalankan tugas (mis. simpan akun) dan tunggu animasi selesai.
      await Future.wait<Object?>([
        widget.tugas?.call() ?? Future<Object?>.value(),
        Future<void>.delayed(_lamaLoading + const Duration(milliseconds: 100)),
      ]);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.pesan)));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const WelcomePage()),
        (route) => false,
      );
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _progres.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Garis progres merah tipis di bagian atas.
            AnimatedBuilder(
              animation: _progres,
              builder: (context, _) => Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _progres.value,
                  child: Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.merah,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.judul,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: AppColors.teks,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TumpukanKartuMinat(
                  gambar: gambarMinatTerpilih(widget.minat),
                ),
              ),
            ),
            const PinspireLogo(ukuran: 60),
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}
