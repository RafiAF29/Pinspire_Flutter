import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../data/galeri_data.dart';
import '../widgets/item_image.dart';
import 'buat_pin_page.dart';

/// Editor hasil kamera: pratinjau + bilah alat (Ukuran, Media, Teks, Stiker,
/// Gambar, Warna). Alat belum berfungsi (tampilan saja).
/// "Berikutnya" -> formulir Buat Pin.
class EditorPinPage extends StatefulWidget {
  final GaleriItem item;
  const EditorPinPage({super.key, required this.item});

  @override
  State<EditorPinPage> createState() => _EditorPinPageState();
}

class _EditorPinPageState extends State<EditorPinPage> {
  void _lanjut() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BuatPinPage(items: [widget.item]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _atas(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ItemImage(widget.item),
                      if (widget.item.video)
                        Positioned(
                          left: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.item.durasi!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            _alat(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _atas() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.chevron_left, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 18),
          const Icon(Icons.help_outline, size: 26, color: Colors.white),
          const Spacer(),
          GestureDetector(
            onTap: _lanjut,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                AppStrings.next,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _alat() {
    Widget alat(Widget isi, String label) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFF3A3A35),
                shape: BoxShape.circle,
              ),
              child: isi,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10.5, color: Colors.white),
            ),
          ],
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        alat(const Icon(Icons.view_quilt, size: 20, color: Colors.white),
            AppStrings.editSize),
        alat(const Icon(Icons.image_outlined, size: 20, color: Colors.white),
            AppStrings.editMedia),
        alat(
          const Text(
            'A',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          AppStrings.editText,
        ),
        alat(const Icon(Icons.sticky_note_2_outlined,
                size: 20, color: Colors.white),
            AppStrings.editSticker),
        alat(const Icon(Icons.draw_outlined, size: 20, color: Colors.white),
            AppStrings.editDraw),
        alat(
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFFA08050),
              shape: BoxShape.circle,
            ),
          ),
          AppStrings.editColor,
        ),
      ],
    );
  }
}
