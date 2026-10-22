import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/navigation/tab_state.dart';
import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/data/auth_repository.dart';
import '../../pin/models/pin.dart';
import '../data/board_store.dart';
import '../data/galeri_data.dart';
import '../data/pengaturan_pin.dart';
import '../data/publish_store.dart';
import '../widgets/buat_papan_sheet.dart';
import '../widgets/item_image.dart';
import '../widgets/pilih_papan_sheet.dart';
import 'papan_page.dart';
import 'pengaturan_lanjutan_page.dart';
import 'tag_produk_page.dart';
import 'tag_topik_page.dart';

/// Formulir Buat Pin: judul, deskripsi, tautan, papan.
/// Tombol "Buat" -> kembali ke Beranda + bar unggah "Menyelesaikan ...".
class BuatPinPage extends StatefulWidget {
  /// Satu atau lebih media. Pin memakai media pertama sebagai sampul.
  final List<GaleriItem> items;
  const BuatPinPage({super.key, required this.items});

  @override
  State<BuatPinPage> createState() => _BuatPinPageState();
}

class _BuatPinPageState extends State<BuatPinPage> {
  final _judulC = TextEditingController();
  final _deskripsiC = TextEditingController();
  final _tautanC = TextEditingController();

  /// null = "Profil" (bawaan).
  Board? _papan;

  List<String> _topik = const [];
  String? _tautanProduk;
  final PengaturanPin _pengaturan = PengaturanPin();

  GaleriItem get _sampul => widget.items.first;

  @override
  void dispose() {
    _judulC.dispose();
    _deskripsiC.dispose();
    _tautanC.dispose();
    super.dispose();
  }

  Future<void> _pilihPapan() async {
    FocusScope.of(context).unfocus();
    final hasil = await showPilihPapanSheet(context, terpilih: _papan);
    if (!mounted || hasil == null) return;

    if (!hasil.buatBaru) {
      setState(() => _papan = hasil.papan);
      return;
    }

    // Buat papan baru -> buka halaman papan; saat kembali, papan itu terpilih.
    final baru = await showBuatPapanSheet(context);
    if (!mounted || baru == null) return;
    setState(() => _papan = baru);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PapanPage(board: baru)),
    );
  }

  Future<void> _pilihTopik() async {
    FocusScope.of(context).unfocus();
    final hasil = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute<List<String>>(
        builder: (_) => TagTopikPage(awal: _topik),
      ),
    );
    if (hasil != null && mounted) setState(() => _topik = hasil);
  }

  Future<void> _tagProduk() async {
    FocusScope.of(context).unfocus();
    final hasil = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const TagProdukPage()),
    );
    if (hasil != null && mounted) setState(() => _tautanProduk = hasil);
  }

  Future<void> _bukaPengaturan() async {
    FocusScope.of(context).unfocus();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PengaturanLanjutanPage(pengaturan: _pengaturan),
      ),
    );
  }

  void _terbitkan() {
    final judul = _judulC.text.trim();
    final deskripsi = _deskripsiC.text.trim();
    final tautan = _tautanC.text.trim();
    final pin = Pin(
      id: 'buat_${DateTime.now().microsecondsSinceEpoch}',
      title: judul.isEmpty ? null : judul,
      image: _sampul.asset,
      aspect: _sampul.aspect,
      bytes: _sampul.bytes,
      fallback: AppColors.chipGrey,
      author: authRepository.akunSaatIni?.nama ?? 'Anda',
      likes: 0,
      comments: 0,
    );
    PublishStore.instance.mulai(
      pin,
      papan: _papan,
      deskripsi: deskripsi.isEmpty ? null : deskripsi,
      tautan: tautan.isEmpty ? null : tautan,
    );
    tabIndex.value = 0;
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Center(child: _pratinjau()),
                    const SizedBox(height: 18),
                    _kolom(
                      label: AppStrings.fieldTitle,
                      hint: AppStrings.hintTitle,
                      controller: _judulC,
                      maxChar: 100,
                      minTinggi: 68,
                      maxBaris: 3,
                    ),
                    _caption(_judulC, 100, AppStrings.maxTitle),
                    const SizedBox(height: 6),
                    _kolom(
                      label: AppStrings.fieldDesc,
                      hint: AppStrings.hintDesc,
                      controller: _deskripsiC,
                      maxChar: 800,
                      minTinggi: 68,
                      maxBaris: 6,
                    ),
                    _caption(_deskripsiC, 800, null),
                    const SizedBox(height: 6),
                    _kolom(
                      label: AppStrings.fieldLink,
                      hint: AppStrings.hintLink,
                      controller: _tautanC,
                      maxChar: 500,
                      minTinggi: 0,
                      maxBaris: 1,
                    ),
                    const SizedBox(height: 10),
                    _baris(
                      AppStrings.chooseBoard,
                      nilai: _papan?.name ?? AppStrings.profile,
                      kunci: _papan?.privat ?? false,
                      onTap: _pilihPapan,
                    ),
                    _baris(
                      AppStrings.tagTopic,
                      nilai: _topik.isEmpty ? null : _topik.join(', '),
                      onTap: _pilihTopik,
                    ),
                    _baris(
                      AppStrings.tagProduct,
                      nilai: _tautanProduk,
                      onTap: _tagProduk,
                    ),
                    _baris(AppStrings.advanced, onTap: _bukaPengaturan),
                  ],
                ),
              ),
            ),
            _bawah(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 52,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Icon(Icons.chevron_left, size: 32, color: Colors.black),
              ),
            ),
          ),
          const Center(
            child: Text(
              AppStrings.createPinTitle,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pratinjau() {
    return SizedBox(
      width: 82,
      height: 110,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ItemImage(_sampul),
            ),
          ),
          if (widget.items.length > 1)
            Positioned(
              left: 5,
              bottom: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.items.length}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kolom({
    required String label,
    required String hint,
    required TextEditingController controller,
    required int maxChar,
    required double minTinggi,
    required int maxBaris,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      constraints: BoxConstraints(minHeight: minTinggi),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: maxBaris,
            inputFormatters: [LengthLimitingTextInputFormatter(maxChar)],
            style: const TextStyle(fontSize: 14, color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 4),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14, color: AppColors.hint),
            ),
          ),
        ],
      ),
    );
  }

  /// Teks kecil di bawah kolom: "Maks 100 karakter" (opsional) + hitungan.
  Widget _caption(TextEditingController c, int maks, String? kiri) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: c,
        builder: (context, nilai, _) => Row(
          children: [
            if (kiri != null)
              Text(
                kiri,
                style: const TextStyle(fontSize: 10, color: AppColors.hint),
              ),
            const Spacer(),
            Text(
              '${nilai.text.length}/$maks',
              style: const TextStyle(fontSize: 10, color: AppColors.hint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _baris(
    String label, {
    String? nilai,
    bool kunci = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            if (nilai != null) ...[
              if (kunci) ...[
                const Icon(Icons.lock_outline, size: 14, color: AppColors.hint),
                const SizedBox(width: 3),
              ],
              Flexible(
                child: Text(
                  nilai,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: AppColors.hint),
                ),
              ),
            ],
            const Icon(Icons.chevron_right, size: 24, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _bawah() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.navBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.chipGrey,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.folder_outlined,
                size: 22, color: Colors.black),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _terbitkan,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                AppStrings.btnCreate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
