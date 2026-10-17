import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/langkah_scaffold.dart';
import '../data/daftar_minat.dart';
import '../models/data_registrasi.dart';
import 'tuning_page.dart';

/// Langkah 7/7 (alur email) atau 3/3 (alur Google): "Apa yang sedang ingin Anda lakukan?".
/// Minimal 3 pilihan agar tombol "Berikutnya" aktif.
class MinatPage extends StatefulWidget {
  const MinatPage({super.key, required this.data});

  final DataRegistrasi data;

  @override
  State<MinatPage> createState() => _MinatPageState();
}

class _MinatPageState extends State<MinatPage> {
  static const int _minimum = 3;

  Set<String> get _dipilih => widget.data.minat;

  void _toggle(String label) {
    setState(() {
      if (!_dipilih.remove(label)) _dipilih.add(label);
    });
  }

  void _lanjut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => TuningPage.registrasi(data: widget.data)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cukup = _dipilih.length >= _minimum;

    return LangkahScaffold(
      totalLangkah: widget.data.totalLangkah,
      langkahSaatIni: widget.data.totalLangkah,
      judul: 'Apa yang sedang ingin Anda lakukan?',
      subjudul: cukup
          ? 'Pilih lainnya untuk mengurasi pengalaman Anda'
          : 'Pilih 3 atau lebih untuk mengurasi pengalaman Anda',
      labelTombol: 'Berikutnya',
      onLanjut: cukup ? _lanjut : null,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 14,
          childAspectRatio: 0.68,
        ),
        itemCount: daftarMinat.length,
        itemBuilder: (context, i) {
          final minat = daftarMinat[i];
          return _KartuMinat(
            minat: minat,
            dipilih: _dipilih.contains(minat.label),
            onTap: () => _toggle(minat.label),
          );
        },
      ),
    );
  }
}

class _KartuMinat extends StatelessWidget {
  const _KartuMinat({
    required this.minat,
    required this.dipilih,
    required this.onTap,
  });

  final Minat minat;
  final bool dipilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Kartu berwarna yang mengintip di balik foto.
                Positioned.fill(
                  top: -4,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: minat.warnaLatar,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(minat.gambar, fit: BoxFit.cover),
                        if (dipilih) const ColoredBox(color: Color(0x22000000)),
                      ],
                    ),
                  ),
                ),
                if (dipilih)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xE6FFFFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.check, size: 22, color: AppColors.teks),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            minat.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: AppColors.teks,
            ),
          ),
        ],
      ),
    );
  }
}
