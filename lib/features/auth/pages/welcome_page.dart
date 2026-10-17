import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/google_logo.dart';
import '../../../core/widgets/pin_button.dart';
import '../../../core/widgets/pin_text_field.dart';
import '../../../core/widgets/pinspire_logo.dart';
import '../data/auth_repository.dart';
import '../models/data_registrasi.dart';
import '../widgets/akun_google_dialog.dart';
import '../widgets/masuk_sheet.dart';
import 'jenis_kelamin_page.dart';
import 'kata_sandi_page.dart';
import 'tuning_page.dart';

/// Halaman awal: "Ciptakan kehidupan yang Anda sukai".
/// Email terdaftar -> sheet Masuk. Email baru -> alur registrasi.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static final RegExp _polaEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static const List<String> _saranDomain = [
    '@gmail.com',
    '@hotmail.com',
    '@yahoo.com',
  ];

  final TextEditingController _emailC = TextEditingController();
  final FocusNode _fokus = FocusNode();
  bool _memuat = false;

  bool get _emailValid => _polaEmail.hasMatch(_emailC.text.trim());

  bool get _tampilkanSaran =>
      _fokus.hasFocus &&
      _emailC.text.isNotEmpty &&
      !_emailC.text.contains('@');

  @override
  void initState() {
    super.initState();
    _emailC.addListener(_ubah);
    _fokus.addListener(_ubah);
  }

  @override
  void dispose() {
    _emailC.removeListener(_ubah);
    _fokus.removeListener(_ubah);
    _emailC.dispose();
    _fokus.dispose();
    super.dispose();
  }

  void _ubah() {
    if (mounted) setState(() {});
  }

  void _tambahDomain(String domain) {
    final baru = _emailC.text + domain;
    _emailC.value = TextEditingValue(
      text: baru,
      selection: TextSelection.collapsed(offset: baru.length),
    );
  }

  /// Setelah masuk: layar loading "Menyesuaikan beranda Anda" dulu
  /// (kartunya mengikuti minat akun), baru Beranda.
  void _keBeranda(AkunPengguna akun) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => TuningPage.masuk(akun: akun)),
      (route) => false,
    );
  }

  Future<void> _lanjutkan() async {
    final email = _emailC.text.trim();
    FocusScope.of(context).unfocus();
    setState(() => _memuat = true);
    final terdaftar = await authRepository.emailTerdaftar(email);
    if (!mounted) return;
    setState(() => _memuat = false);

    if (terdaftar) {
      final akun = await tampilkanMasukSheet(context, email: email);
      if (akun != null && mounted) _keBeranda(akun);
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => KataSandiPage(data: DataRegistrasi(email: email)),
        ),
      );
    }
  }

  Future<void> _lanjutkanGoogle() async {
    FocusScope.of(context).unfocus();
    final akun = await tampilkanAkunGoogleDialog(context);
    if (akun == null || !mounted) return;

    if (await authRepository.emailTerdaftar(akun.email)) {
      final pengguna = await authRepository.masukDenganGoogle(akun);
      if (mounted) _keBeranda(pengguna);
    } else {
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => JenisKelaminPage(
            data: DataRegistrasi(
              email: akun.email,
              nama: akun.nama,
              daftarDenganGoogle: true,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const teksLegal = TextStyle(fontSize: 13, height: 1.4, color: AppColors.teks);
    const tautan = TextStyle(
      fontSize: 13,
      height: 1.4,
      color: AppColors.teks,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                const _Kolase(),
                const SizedBox(height: 14),
                const Text(
                  'Ciptakan kehidupan\nyang Anda sukai',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: AppColors.teks,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      PinTextField(
                        controller: _emailC,
                        focusNode: _fokus,
                        label: 'Email',
                        hint: 'Masukkan email Anda',
                        tampilkanHapus: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (_emailValid && !_memuat) _lanjutkan();
                        },
                      ),
                      const SizedBox(height: 8),
                      PinButton(
                        label: 'Lanjutkan',
                        memuat: _memuat,
                        onPressed: _emailValid ? _lanjutkan : null,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Atau',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.teksSekunder,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PinButton(
                        label: 'Lanjutkan dengan Google',
                        gaya: PinButtonGaya.sekunder,
                        leading: const GoogleLogo(ukuran: 22),
                        onPressed: _lanjutkanGoogle,
                      ),
                      const SizedBox(height: 14),
                      Text.rich(
                        TextSpan(
                          style: teksLegal,
                          children: [
                            const TextSpan(
                              text:
                                  'Anda harus berusia minimum 16 tahun untuk menggunakan Pinspire. Dengan melanjutkan, Anda menyetujui ',
                            ),
                            const TextSpan(text: 'Persyaratan Layanan', style: tautan),
                            const TextSpan(
                              text:
                                  ' Pinspire dan menyatakan bahwa Anda telah membaca ',
                            ),
                            const TextSpan(text: 'Kebijakan Privasi', style: tautan),
                            const TextSpan(text: '. '),
                            const TextSpan(
                              text: 'Pemberitahuan saat persetujuan diminta',
                              style: tautan,
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Ruang ekstra agar teks legal tidak tertutup saran domain.
                      SizedBox(height: _tampilkanSaran ? 48 : 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_tampilkanSaran)
            Positioned(
              left: 16,
              right: 16,
              bottom: 8,
              child: Row(
                children: [
                  for (final domain in _saranDomain)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Material(
                          color: AppColors.abuMuda,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => _tambahDomain(domain),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              child: Text(
                                domain,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.teks,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Kolase foto di bagian atas + logo Pinspire di tengah bawahnya.
class _Kolase extends StatelessWidget {
  const _Kolase();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 738 / 580,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/collage.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const Align(
            alignment: Alignment(0, 0.82),
            child: PinspireLogo(ukuran: 44),
          ),
        ],
      ),
    );
  }
}
