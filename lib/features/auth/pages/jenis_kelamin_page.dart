import 'package:flutter/material.dart';

import '../../../core/widgets/langkah_scaffold.dart';
import '../../../core/widgets/pin_button.dart';
import '../models/data_registrasi.dart';
import 'negara_page.dart';

/// Langkah 5/7 (alur email) atau 1/3 (alur Google): "Apa jenis kelamin Anda?".
/// Memilih salah satu pilihan langsung melanjutkan ke langkah berikutnya.
class JenisKelaminPage extends StatelessWidget {
  const JenisKelaminPage({super.key, required this.data});

  final DataRegistrasi data;

  void _pilih(BuildContext context, JenisKelamin jenis) {
    data.jenisKelamin = jenis;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => NegaraPage(data: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LangkahScaffold(
      totalLangkah: data.totalLangkah,
      langkahSaatIni: data.daftarDenganGoogle ? 1 : 5,
      judul: 'Apa jenis kelamin Anda?',
      subjudul:
          'Tindakan ini membantu kami menemukan konten yang lebih relevan untuk Anda. Kami tidak akan menampilkannya di profil Anda.',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            PinButton(
              label: 'Wanita',
              gaya: PinButtonGaya.netral,
              tinggi: 44,
              onPressed: () => _pilih(context, JenisKelamin.wanita),
            ),
            const SizedBox(height: 8),
            PinButton(
              label: 'Pria',
              gaya: PinButtonGaya.netral,
              tinggi: 44,
              onPressed: () => _pilih(context, JenisKelamin.pria),
            ),
            const SizedBox(height: 8),
            PinButton(
              label: 'Tentukan yang lain',
              gaya: PinButtonGaya.netral,
              tinggi: 44,
              onPressed: () => _pilih(context, JenisKelamin.lainnya),
            ),
          ],
        ),
      ),
    );
  }
}
