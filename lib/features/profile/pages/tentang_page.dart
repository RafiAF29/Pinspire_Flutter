import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/widgets/header_halaman.dart';
import '../../../core/widgets/kolom_berlabel.dart';

/// Halaman "Tentang" (bio singkat). Mengembalikan bio baru lewat `pop`.
Future<String?> bukaTentang(BuildContext context, String awal) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute<String>(builder: (_) => _TentangPage(awal: awal)),
  );
}

class _TentangPage extends StatefulWidget {
  const _TentangPage({required this.awal});

  final String awal;

  @override
  State<_TentangPage> createState() => _TentangPageState();
}

class _TentangPageState extends State<_TentangPage> {
  static const int _maks = 160;

  late final TextEditingController _c = TextEditingController(text: widget.awal);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final berubah = _c.text.trim() != widget.awal.trim();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderHalaman(
              judul: AppStrings.about,
              onKiri: () => Navigator.of(context).pop(),
              kanan: TombolPil(
                label: AppStrings.done,
                aktif: berubah,
                onTap: () => Navigator.of(context).pop(_c.text.trim()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: KolomBerlabel(
                label: AppStrings.about,
                hint: AppStrings.aboutHint,
                controller: _c,
                maxChar: _maks,
                maxBaris: 5,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_c.text.length}/$_maks',
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF76766B)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
