import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/langkah_scaffold.dart';
import '../../../core/widgets/pin_text_field.dart';
import '../models/data_registrasi.dart';
import 'nama_page.dart';

/// Langkah 2/7: "Buat kata sandi".
class KataSandiPage extends StatefulWidget {
  const KataSandiPage({super.key, required this.data});

  final DataRegistrasi data;

  @override
  State<KataSandiPage> createState() => _KataSandiPageState();
}

class _KataSandiPageState extends State<KataSandiPage> {
  final TextEditingController _sandiC = TextEditingController();

  bool get _cukupPanjang => _sandiC.text.length >= 8;

  @override
  void dispose() {
    _sandiC.dispose();
    super.dispose();
  }

  void _lanjut() {
    widget.data.kataSandi = _sandiC.text;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => NamaPage(data: widget.data)),
    );
  }

  void _tampilkanTips() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tips kata sandi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            _Tip('Gunakan minimal 8 karakter.'),
            _Tip('Campurkan huruf besar dan huruf kecil.'),
            _Tip('Tambahkan angka dan simbol.'),
            _Tip('Hindari nama, email, atau tanggal lahir Anda.'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kekuatan = _hitungKekuatan(_sandiC.text);

    return LangkahScaffold(
      totalLangkah: widget.data.totalLangkah,
      langkahSaatIni: 2,
      judul: 'Buat kata sandi',
      labelTombol: 'Berikutnya',
      onLanjut: _cukupPanjang ? _lanjut : null,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PinTextField(
              controller: _sandiC,
              label: 'Kata sandi',
              hint: 'Buat kata sandi yang kuat',
              togglePassword: true,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) {
                if (_cukupPanjang) _lanjut();
              },
            ),
            if (kekuatan != null) ...[
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: kekuatan.nilai,
                  minHeight: 6,
                  backgroundColor: AppColors.abuMuda,
                  color: AppColors.kekuatan,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kekuatan.label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              const Text(
                'Gunakan huruf, angka, dan simbol sepanjang 8 karakter atau lebih',
                style: TextStyle(fontSize: 14, color: AppColors.teksSekunder),
              ),
            ],
            const SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _tampilkanTips,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tips kata sandi',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.info_outline, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip(this.teks);

  final String teks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.check_circle_outline, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(teks, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

class _Kekuatan {
  const _Kekuatan(this.nilai, this.label);

  final double nilai;
  final String label;
}

/// Null bila belum ada isian.
_Kekuatan? _hitungKekuatan(String sandi) {
  if (sandi.isEmpty) return null;
  if (sandi.length < 8) return const _Kekuatan(0.2, 'Terlalu lemah');

  var jenis = 0;
  if (RegExp(r'[a-z]').hasMatch(sandi)) jenis++;
  if (RegExp(r'[A-Z]').hasMatch(sandi)) jenis++;
  if (RegExp(r'[0-9]').hasMatch(sandi)) jenis++;
  if (RegExp(r'[^A-Za-z0-9]').hasMatch(sandi)) jenis++;

  switch (jenis) {
    case 1:
      return const _Kekuatan(0.6, 'Tampak bagus');
    case 2:
      return const _Kekuatan(0.75, 'Bagus');
    case 3:
      return const _Kekuatan(0.9, 'Kuat');
    default:
      return const _Kekuatan(1.0, 'Sangat kuat');
  }
}
