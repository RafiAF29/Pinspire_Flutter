import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dialog_memuat.dart';
import '../../../core/widgets/google_logo.dart';
import '../../../core/widgets/pin_button.dart';
import '../../../core/widgets/pin_text_field.dart';
import '../data/auth_repository.dart';
import '../models/data_registrasi.dart';
import 'akun_google_dialog.dart';

/// Sheet "Masuk" yang naik dari bawah ketika email sudah terdaftar.
/// Mengembalikan [AkunPengguna] bila berhasil masuk, null bila ditutup.
Future<AkunPengguna?> tampilkanMasukSheet(
  BuildContext context, {
  required String email,
}) {
  return showModalBottomSheet<AkunPengguna>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => _MasukSheet(emailAwal: email),
  );
}

class _MasukSheet extends StatefulWidget {
  const _MasukSheet({required this.emailAwal});

  final String emailAwal;

  @override
  State<_MasukSheet> createState() => _MasukSheetState();
}

class _MasukSheetState extends State<_MasukSheet> {
  late final TextEditingController _emailC =
      TextEditingController(text: widget.emailAwal);
  final TextEditingController _sandiC = TextEditingController();

  static final RegExp _polaEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String? _errorEmail;
  String? _errorSandi;
  String? _pesanInfo;

  @override
  void dispose() {
    _emailC.dispose();
    _sandiC.dispose();
    super.dispose();
  }

  // Pesan ditampilkan di dalam sheet (SnackBar akan tertutup oleh sheet).
  void _info(String pesan) {
    setState(() => _pesanInfo = pesan);
  }

  Future<void> _masuk() async {
    final email = _emailC.text.trim();
    final sandi = _sandiC.text;

    setState(() {
      _errorEmail = _polaEmail.hasMatch(email) ? null : 'Masukkan alamat email yang valid.';
      _errorSandi = sandi.isEmpty ? 'Masukkan kata sandi Anda.' : null;
    });
    if (_errorEmail != null || _errorSandi != null) return;

    FocusScope.of(context).unfocus();
    tampilkanDialogMemuat(context);
    try {
      final akun = await authRepository.masuk(email: email, kataSandi: sandi);
      if (!mounted) return;
      tutupDialogMemuat(context);
      Navigator.of(context).pop(akun);
    } on AuthException catch (e) {
      if (!mounted) return;
      tutupDialogMemuat(context);
      setState(() => _errorSandi = e.pesan);
    }
  }

  Future<void> _masukGoogle() async {
    final akun = await tampilkanAkunGoogleDialog(context);
    if (akun == null || !mounted) return;
    if (!await authRepository.emailTerdaftar(akun.email)) {
      if (!mounted) return;
      _info('Akun Google ini belum terdaftar. Tutup lalu pilih "Lanjutkan dengan Google" untuk mendaftar.');
      return;
    }
    final pengguna = await authRepository.masukDenganGoogle(akun);
    if (!mounted) return;
    Navigator.of(context).pop(pengguna);
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: FractionallySizedBox(
        heightFactor: 0.93,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        padding: const EdgeInsets.all(16),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 28, color: AppColors.teks),
                      ),
                    ),
                    const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teks,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PinButton(
                        label: 'Masuk dengan Google',
                        gaya: PinButtonGaya.sekunder,
                        leading: const GoogleLogo(ukuran: 22),
                        onPressed: _masukGoogle,
                      ),
                      const SizedBox(height: 8),
                      PinButton(
                        label: 'Masuk tanpa kata sandi',
                        gaya: PinButtonGaya.sekunder,
                        leading: const Icon(Icons.mail_outline,
                            size: 24, color: AppColors.teks),
                        onPressed: () =>
                            _info('Masuk tanpa kata sandi segera hadir.'),
                      ),
                      const SizedBox(height: 14),
                      const Center(
                        child: Text(
                          'Atau',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      PinTextField(
                        controller: _emailC,
                        label: 'Email',
                        hint: 'Masukkan email Anda',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        errorText: _errorEmail,
                        onChanged: (_) {
                          if (_errorEmail != null) setState(() => _errorEmail = null);
                        },
                      ),
                      const SizedBox(height: 8),
                      PinTextField(
                        controller: _sandiC,
                        label: 'Kata sandi',
                        hint: 'Masukkan kata sandi',
                        togglePassword: true,
                        textInputAction: TextInputAction.done,
                        errorText: _errorSandi,
                        onChanged: (_) {
                          if (_errorSandi != null) setState(() => _errorSandi = null);
                        },
                        onSubmitted: (_) => _masuk(),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _info('Pemulihan kata sandi segera hadir.'),
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.tautan,
                          ),
                        ),
                      ),
                      if (_pesanInfo != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _pesanInfo!,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.3,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      PinButton(label: 'Masuk', onPressed: _masuk),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
