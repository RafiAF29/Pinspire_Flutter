import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/navigation/pindah_tab.dart';
import '../../../core/strings.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/header_halaman.dart';
import '../../../core/widgets/masonry_grid.dart';
import '../../../core/widgets/pin_image.dart';
import '../../pin/data/pin_repository.dart';
import '../../pin/data/saved_store.dart';
import '../../pin/models/pin.dart';
import '../data/board_store.dart';
import 'papan_page.dart';

/// Halaman "Tambahkan Pin" (setelah papan dibuat, atau dari tombol
/// "Tambahkan" di halaman papan).
/// - Ketuk Pin     -> langsung masuk ke papan (ikon centang).
/// - Ketuk lagi    -> keluar dari papan + toast "Dihapus!".
/// - "Selesai"     -> buka halaman papan (atau kembali bila sudah dari sana).
class TambahPinPage extends StatefulWidget {
  const TambahPinPage({
    super.key,
    required this.board,
    this.lanjutKePapan = false,
  });

  final Board board;

  /// true = alur buat papan baru: "Selesai" mengganti halaman ini dengan
  /// halaman papan. false = dibuka dari halaman papan: "Selesai" kembali.
  final bool lanjutKePapan;

  @override
  State<TambahPinPage> createState() => _TambahPinPageState();
}

class _TambahPinPageState extends State<TambahPinPage> {
  bool _toast = false;
  Timer? _timer;

  /// Pin yang sudah disimpan tampil dulu, lalu pin dari beranda
  /// (urutan dibuat sekali di awal).
  late final List<Pin> _semuaPin = _susunPin();

  List<Pin> _susunPin() {
    final hasil = <Pin>[...SavedStore.instance.pins];
    final repo = PinRepository.instance;
    for (final p in [...repo.homeLeftColumn(), ...repo.homeRightColumn()]) {
      if (!hasil.any((e) => e.id == p.id)) hasil.add(p);
    }
    return hasil;
  }

  bool _terpilih(Pin p) => widget.board.pins.any((e) => e.id == p.id);

  void _ketuk(Pin p) {
    final store = BoardStore.instance;
    if (_terpilih(p)) {
      store.hapusPin(widget.board, p);
      _timer?.cancel();
      setState(() => _toast = true);
      _timer = Timer(const Duration(milliseconds: 2200), () {
        if (mounted) setState(() => _toast = false);
      });
    } else {
      // Pin yang masuk ke papan otomatis ikut tersimpan.
      if (!SavedStore.instance.isSaved(p)) SavedStore.instance.save(p);
      store.tambahPin(widget.board, p);
    }
  }

  void _selesai() {
    if (widget.lanjutKePapan) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => PapanPage(board: widget.board)),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pins = _semuaPin; // urutan dibuat sekali supaya grid tidak loncat
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                HeaderHalaman(
                  judul: AppStrings.addPins,
                  ikonKiri: Icons.close,
                  onKiri: () => Navigator.of(context).pop(),
                  kanan: TombolPil(
                    label: AppStrings.done,
                    aktif: true,
                    onTap: _selesai,
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      BoardStore.instance,
                      SavedStore.instance,
                    ]),
                    builder: (context, _) => SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(4, 6, 4, 16),
                      child: MasonryGrid<Pin>(
                        items: pins,
                        columns: 2,
                        crossSpacing: 4,
                        mainSpacing: 4,
                        aspectOf: (p) => p.aspect,
                        itemBuilder: (context, p) => _Kotak(
                          key: ValueKey('tambah-${p.id}'),
                          pin: p,
                          terpilih: _terpilih(p),
                          onTap: () => _ketuk(p),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 6,
              left: 12,
              right: 12,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: _toast ? 1 : 0,
                  child: Container(
                    height: 48,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A36),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      AppStrings.removedToast,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PinBottomNav(
        index: 0,
        onTap: (i) => pindahTab(context, i),
      ),
    );
  }
}

/// Satu Pin di grid: gambar + ikon pin (belum dipilih) / centang (dipilih).
class _Kotak extends StatelessWidget {
  const _Kotak({
    super.key,
    required this.pin,
    required this.terpilih,
    required this.onTap,
  });

  final Pin pin;
  final bool terpilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: pin.aspect,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PinImage(pin),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: terpilih
                        ? Colors.black
                        : const Color(0xB3FFFFFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    terpilih ? Icons.check : Icons.push_pin,
                    size: 14,
                    color: terpilih ? Colors.white : Colors.black,
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
