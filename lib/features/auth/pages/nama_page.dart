import 'package:flutter/material.dart';

import '../../../core/widgets/langkah_scaffold.dart';
import '../../../core/widgets/pin_text_field.dart';
import '../models/data_registrasi.dart';
import 'tanggal_lahir_page.dart';

/// Langkah 3/7: "Siapa nama Anda?".
class NamaPage extends StatefulWidget {
  const NamaPage({super.key, required this.data});

  final DataRegistrasi data;

  @override
  State<NamaPage> createState() => _NamaPageState();
}

class _NamaPageState extends State<NamaPage> {
  final TextEditingController _namaC = TextEditingController();

  bool get _valid => _namaC.text.trim().isNotEmpty;

  @override
  void dispose() {
    _namaC.dispose();
    super.dispose();
  }

  void _lanjut() {
    widget.data.nama = _namaC.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TanggalLahirPage(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LangkahScaffold(
      totalLangkah: widget.data.totalLangkah,
      langkahSaatIni: 3,
      judul: 'Siapa nama Anda?',
      labelTombol: 'Berikutnya',
      onLanjut: _valid ? _lanjut : null,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PinTextField(
          controller: _namaC,
          hint: 'Nama',
          tampilkanHapus: true,
          autofocus: true,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) {
            if (_valid) _lanjut();
          },
        ),
      ),
    );
  }
}
