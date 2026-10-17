import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

const List<String> namaBulanSingkat = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

String formatTanggal(DateTime t) =>
    '${t.day} ${namaBulanSingkat[t.month - 1]} ${t.year}';

/// Dialog roda pemilih tanggal (hari - bulan - tahun) dengan tombol Batal / Oke.
Future<DateTime?> tampilkanPemilihTanggal(
  BuildContext context, {
  required DateTime awal,
  required DateTime pertama,
  required DateTime terakhir,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => _PemilihTanggalDialog(
      awal: awal,
      pertama: pertama,
      terakhir: terakhir,
    ),
  );
}

class _PemilihTanggalDialog extends StatefulWidget {
  const _PemilihTanggalDialog({
    required this.awal,
    required this.pertama,
    required this.terakhir,
  });

  final DateTime awal;
  final DateTime pertama;
  final DateTime terakhir;

  @override
  State<_PemilihTanggalDialog> createState() => _PemilihTanggalDialogState();
}

class _PemilihTanggalDialogState extends State<_PemilihTanggalDialog> {
  late int _hari = widget.awal.day;
  late int _bulan = widget.awal.month;
  late int _tahun = widget.awal.year;

  late final FixedExtentScrollController _cHari =
      FixedExtentScrollController(initialItem: _hari - 1);
  late final FixedExtentScrollController _cBulan =
      FixedExtentScrollController(initialItem: _bulan - 1);
  late final FixedExtentScrollController _cTahun = FixedExtentScrollController(
      initialItem: _tahun - widget.pertama.year);

  int get _jumlahHari => DateUtils.getDaysInMonth(_tahun, _bulan);
  int get _jumlahTahun => widget.terakhir.year - widget.pertama.year + 1;

  @override
  void dispose() {
    _cHari.dispose();
    _cBulan.dispose();
    _cTahun.dispose();
    super.dispose();
  }

  /// Jika hari melebihi jumlah hari pada bulan terpilih (mis. 31 Feb), mundurkan.
  void _koreksiHari() {
    final maks = _jumlahHari;
    if (_hari > maks) {
      _hari = maks;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _cHari.hasClients) _cHari.jumpToItem(maks - 1);
      });
    }
  }

  void _oke() {
    var hasil = DateTime(_tahun, _bulan, _hari);
    if (hasil.isAfter(widget.terakhir)) hasil = widget.terakhir;
    Navigator.of(context).pop(hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Roda(
                  lebar: 64,
                  controller: _cHari,
                  jumlah: _jumlahHari,
                  terpilih: _hari - 1,
                  label: (i) => '${i + 1}',
                  onChanged: (i) => setState(() => _hari = i + 1),
                ),
                _Roda(
                  lebar: 64,
                  controller: _cBulan,
                  jumlah: 12,
                  terpilih: _bulan - 1,
                  label: (i) => namaBulanSingkat[i],
                  onChanged: (i) => setState(() {
                    _bulan = i + 1;
                    _koreksiHari();
                  }),
                ),
                _Roda(
                  lebar: 64,
                  controller: _cTahun,
                  jumlah: _jumlahTahun,
                  terpilih: _tahun - widget.pertama.year,
                  label: (i) => '${widget.pertama.year + i}',
                  onChanged: (i) => setState(() {
                    _tahun = widget.pertama.year + i;
                    _koreksiHari();
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: AppColors.teks,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _oke,
                  child: const Text(
                    'Oke',
                    style: TextStyle(
                      color: AppColors.teks,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu roda (kolom) pemilih, dengan dua garis penanda merah muda di tengah.
class _Roda extends StatelessWidget {
  const _Roda({
    required this.lebar,
    required this.controller,
    required this.jumlah,
    required this.terpilih,
    required this.label,
    required this.onChanged,
  });

  static const double _tinggiItem = 60;

  final double lebar;
  final FixedExtentScrollController controller;
  final int jumlah;
  final int terpilih;
  final String Function(int index) label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: lebar,
      height: _tinggiItem * 3,
      child: Stack(
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: _tinggiItem,
            diameterRatio: 8,
            perspective: 0.0005,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: jumlah,
              builder: (context, i) => Center(
                child: Text(
                  label(i),
                  style: TextStyle(
                    fontSize: 16,
                    color: i == terpilih
                        ? AppColors.teks
                        : const Color(0xFFB5B5B5),
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                height: _tinggiItem,
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: AppColors.garisRoda, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
