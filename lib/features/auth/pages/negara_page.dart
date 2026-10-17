import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/langkah_scaffold.dart';
import '../models/data_registrasi.dart';
import 'minat_page.dart';
import 'pilih_negara_page.dart';

/// Langkah 6/7 (alur email) atau 2/3 (alur Google): "Apa negara atau wilayah Anda?".
class NegaraPage extends StatefulWidget {
  const NegaraPage({super.key, required this.data});

  final DataRegistrasi data;

  @override
  State<NegaraPage> createState() => _NegaraPageState();
}

class _NegaraPageState extends State<NegaraPage> {
  Future<void> _pilihNegara() async {
    final hasil = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => PilihNegaraPage(terpilih: widget.data.negara),
      ),
    );
    if (hasil != null && mounted) {
      setState(() => widget.data.negara = hasil);
    }
  }

  void _lanjut() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => MinatPage(data: widget.data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LangkahScaffold(
      totalLangkah: widget.data.totalLangkah,
      langkahSaatIni: widget.data.daftarDenganGoogle ? 2 : 6,
      judul: 'Apa negara atau wilayah Anda?',
      subjudul:
          'Tindakan ini membantu kami menemukan konten yang lebih relevan untuk Anda. Kami tidak akan menampilkannya di profil Anda.',
      labelTombol: 'Berikutnya',
      onLanjut: _lanjut,
      child: Align(
        alignment: Alignment.topCenter,
        child: InkWell(
          onTap: _pilihNegara,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.data.negara,
                    style: const TextStyle(fontSize: 16, color: AppColors.teks),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 26, color: AppColors.teks),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
