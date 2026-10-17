import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/header_halaman.dart';

/// "Beri tag topik": cari / pilih topik terkait Pin.
/// Mengembalikan daftar topik yang dipilih saat "Selesai" ditekan.
class TagTopikPage extends StatefulWidget {
  const TagTopikPage({super.key, this.awal = const []});

  final List<String> awal;

  @override
  State<TagTopikPage> createState() => _TagTopikPageState();
}

class _TagTopikPageState extends State<TagTopikPage> {
  /// Saran awal (muncul saat kolom diketuk).
  static const List<String> _saranAwal = [
    'Pakaian Topik Trending',
    'Teks Lucu',
    'Humor Pesan Teks',
    'Topik Trending',
  ];

  /// Seluruh topik yang bisa dicari. Nanti diganti API (GET /topics?q=).
  static const List<String> _semua = [
    ..._saranAwal,
    'Dekorasi Rumah',
    'Hewan Lucu',
    'Estetika',
    'Resep Masakan',
    'Pantai',
    'Villa',
    'Liburan',
    'Fotografi',
    'Inspirasi Busana',
    'Kutipan Harian',
    'Seni Digital',
    'Ide Pesta',
  ];

  final TextEditingController _c = TextEditingController();
  final FocusNode _fokus = FocusNode();
  late final List<String> _dipilih = [...widget.awal];

  @override
  void initState() {
    super.initState();
    _c.addListener(_ubah);
    _fokus.addListener(_ubah);
  }

  void _ubah() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _c.dispose();
    _fokus.dispose();
    super.dispose();
  }

  void _toggle(String topik) {
    setState(() {
      if (!_dipilih.remove(topik)) _dipilih.add(topik);
    });
  }

  /// Topik yang ditawarkan (selain yang sudah dipilih).
  List<String> get _tawaran {
    final q = _c.text.trim().toLowerCase();
    final sumber = q.isEmpty
        ? _saranAwal
        : _semua.where((t) => t.toLowerCase().contains(q));
    return [
      for (final t in sumber)
        if (!_dipilih.contains(t)) t,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final adaDipilih = _dipilih.isNotEmpty;
    final tampilChip = _fokus.hasFocus || adaDipilih || _c.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderHalaman(
              judul: AppStrings.tagTopic,
              onKiri: () => Navigator.of(context).pop(),
              kanan: TombolPil(
                label: AppStrings.done,
                aktif: adaDipilih,
                onTap: () => Navigator.of(context).pop(List<String>.of(_dipilih)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kolomCari(),
                    const SizedBox(height: 14),
                    if (!adaDipilih)
                      const Text(
                        AppStrings.tagTopicDesc,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                          color: Colors.black,
                        ),
                      ),
                    if (adaDipilih) ...[
                      const Text(
                        AppStrings.selected,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in _dipilih)
                            _ChipTopik(
                              label: t,
                              dipilih: true,
                              onTap: () => _toggle(t),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (tampilChip) ...[
                      if (!adaDipilih) const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in _tawaran)
                            _ChipTopik(
                              label: t,
                              dipilih: false,
                              onTap: () => _toggle(t),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kolomCari() {
    final fokus = _fokus.hasFocus;
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: fokus ? Colors.black : AppColors.outline,
          width: fokus ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          if (!fokus && _c.text.isEmpty) ...[
            const Icon(Icons.search, size: 20, color: Colors.black),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              controller: _c,
              focusNode: _fokus,
              cursorColor: Colors.red,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 14.5, color: Colors.black),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: AppStrings.searchTopic,
                hintStyle: TextStyle(fontSize: 14.5, color: AppColors.hint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipTopik extends StatelessWidget {
  const _ChipTopik({
    required this.label,
    required this.dipilih,
    required this.onTap,
  });

  final String label;
  final bool dipilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dipilih ? AppColors.dark : AppColors.chipGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: dipilih ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
