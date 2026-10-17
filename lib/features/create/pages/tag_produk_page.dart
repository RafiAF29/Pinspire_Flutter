import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';

/// "Berikan tag pada produk": tab Cari Pin / Gunakan tautan.
/// Mengembalikan tautan produk (String) bila ada yang ditambahkan.
class TagProdukPage extends StatefulWidget {
  const TagProdukPage({super.key});

  @override
  State<TagProdukPage> createState() => _TagProdukPageState();
}

class _TagProdukPageState extends State<TagProdukPage> {
  int _tab = 0; // 0 = Cari Pin, 1 = Gunakan tautan
  final TextEditingController _cariC = TextEditingController();
  final TextEditingController _tautanC = TextEditingController();

  @override
  void dispose() {
    _cariC.dispose();
    _tautanC.dispose();
    super.dispose();
  }

  void _kirimTautan(String teks) {
    final bersih = teks.trim();
    if (bersih.isEmpty) return;
    Navigator.of(context).pop(bersih);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, size: 26, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 28),
                  _tabItem(AppStrings.findPin, 0),
                  const SizedBox(width: 20),
                  _tabItem(AppStrings.useLink, 1),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(child: _tab == 0 ? _cariPin() : _gunakanTautan()),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String teks, int i) {
    final pilih = _tab == i;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _tab = i),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            teks,
            style: TextStyle(
              fontSize: 14,
              fontWeight: pilih ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Container(height: 2, width: pilih ? 56 : 0, color: Colors.black),
        ],
      ),
    );
  }

  Widget _cariPin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kolom(
            controller: _cariC,
            hint: AppStrings.searchByProduct,
            ikon: Icons.search,
          ),
          // Balon penjelasan dengan segitiga kecil di atasnya.
          Padding(
            padding: const EdgeInsets.only(left: 36, top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomPaint(
                  size: const Size(18, 9),
                  painter: _SegitigaAtas(AppColors.dark),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 190),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    AppStrings.productTooltip,
                    style: TextStyle(fontSize: 13.5, color: Colors.white, height: 1.25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gunakanTautan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kolom(
            controller: _tautanC,
            hint: AppStrings.addProductLink,
            ikon: Icons.language,
            onSubmitted: _kirimTautan,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              AppStrings.productLinkDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.3, color: AppColors.teksSekunder),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kolom({
    required TextEditingController controller,
    required String hint,
    required IconData ikon,
    ValueChanged<String>? onSubmitted,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Icon(ikon, size: 20, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              keyboardType: keyboardType,
              cursorColor: Colors.red,
              style: const TextStyle(fontSize: 14.5, color: Colors.black),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 14.5, color: AppColors.hint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegitigaAtas extends CustomPainter {
  _SegitigaAtas(this.warna);

  final Color warna;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = warna);
  }

  @override
  bool shouldRepaint(covariant _SegitigaAtas old) => old.warna != warna;
}
