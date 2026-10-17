import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../create/pages/kamera_page.dart';
import '../data/search_repository.dart';

/// Layar mengetik pencarian: kolom "Cari ide" + tombol Batal, lalu daftar
/// saran saat mengetik.
///
/// Mengembalikan teks yang dicari lewat `Navigator.pop`, atau null kalau Batal.
class SearchInputPage extends StatefulWidget {
  const SearchInputPage({super.key, this.awal = ''});

  /// Teks awal di kolom (dipakai saat mengubah pencarian dari halaman hasil).
  final String awal;

  @override
  State<SearchInputPage> createState() => _SearchInputPageState();
}

class _SearchInputPageState extends State<SearchInputPage> {
  late final TextEditingController _c = TextEditingController(text: widget.awal)
    ..selection = TextSelection.collapsed(offset: widget.awal.length);

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _bukaKamera() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const KameraPage(untukCari: true)),
    );
  }

  void _kirim(String teks) {
    final bersih = teks.trim();
    if (bersih.isEmpty) return;
    Navigator.of(context).pop(bersih);
  }

  @override
  Widget build(BuildContext context) {
    final saran = SearchRepository.instance.saran(_c.text);
    final diketik = _c.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: Row(
                children: [
                  Expanded(child: _kolom()),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: const Text(
                      AppStrings.cancel,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(top: 4),
                itemCount: saran.length,
                itemBuilder: (context, i) => _BarisSaran(
                  teks: saran[i],
                  diketik: diketik,
                  onTap: () => _kirim(saran[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kolom() {
    return Container(
      height: 46,
      padding: const EdgeInsets.only(left: 16, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _c,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: _kirim,
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: AppStrings.searchHint,
                hintStyle: TextStyle(fontSize: 15, color: AppColors.hint),
              ),
            ),
          ),
          if (_c.text.isEmpty)
            GestureDetector(
              key: const ValueKey('cari-kamera'),
              behavior: HitTestBehavior.opaque,
              onTap: _bukaKamera,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.photo_camera_outlined, size: 22, color: Colors.black),
              ),
            )
          else
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _c.clear,
              child: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(Icons.cancel_outlined, size: 22, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}

/// Satu baris saran: bagian yang sudah diketik biasa, sisanya tebal.
class _BarisSaran extends StatelessWidget {
  const _BarisSaran({
    required this.teks,
    required this.diketik,
    required this.onTap,
  });

  final String teks;
  final String diketik;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cocok = teks.startsWith(diketik);
    final depan = cocok ? diketik : teks;
    final belakang = cocok ? teks.substring(diketik.length) : '';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 14.5, color: Colors.black),
                  children: [
                    TextSpan(text: depan),
                    TextSpan(
                      text: belakang,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
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
