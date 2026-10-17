import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/header_halaman.dart';
import '../../../core/widgets/kolom_berlabel.dart';
import '../../../core/widgets/switch_pin.dart';
import '../data/pengaturan_pin.dart';

/// "Pengaturan Lanjutan" di Buat Pin: komentar, teks alt, rekomendasi
/// belanja, pengungkapan AI. [pengaturan] diubah langsung.
class PengaturanLanjutanPage extends StatefulWidget {
  const PengaturanLanjutanPage({super.key, required this.pengaturan});

  final PengaturanPin pengaturan;

  @override
  State<PengaturanLanjutanPage> createState() => _PengaturanLanjutanPageState();
}

class _PengaturanLanjutanPageState extends State<PengaturanLanjutanPage> {
  static const int _maksAlt = 500;

  PengaturanPin get _p => widget.pengaturan;
  late final TextEditingController _altC =
      TextEditingController(text: _p.teksAlt);

  @override
  void dispose() {
    _altC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderHalaman(
              judul: AppStrings.advanced,
              onKiri: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _judulBagian(AppStrings.engagementSettings),
                    _barisSwitch(
                      AppStrings.allowComments,
                      null,
                      _p.izinkanKomentar,
                      (v) => setState(() => _p.izinkanKomentar = v),
                    ),
                    const SizedBox(height: 10),
                    KolomBerlabel(
                      label: AppStrings.altText,
                      hint: AppStrings.altTextHint,
                      controller: _altC,
                      maxChar: _maksAlt,
                      maxBaris: 4,
                      onChanged: (v) => setState(() => _p.teksAlt = v),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              AppStrings.altTextDesc,
                              style: TextStyle(fontSize: 10.5, color: AppColors.hint),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_altC.text.length}/$_maksAlt',
                            style: const TextStyle(fontSize: 10.5, color: AppColors.hint),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    _judulBagian(AppStrings.shoppingRecs),
                    _barisSwitch(
                      AppStrings.showSimilarProducts,
                      AppStrings.showSimilarProductsDesc,
                      _p.tampilkanProdukSerupa,
                      (v) => setState(() => _p.tampilkanProdukSerupa = v),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      AppStrings.shoppingRecsNote,
                      style: TextStyle(fontSize: 12, height: 1.3, color: AppColors.teksSekunder),
                    ),
                    const SizedBox(height: 22),
                    _judulBagian(AppStrings.aiDisclosure),
                    _barisSwitch(
                      AppStrings.markAiModified,
                      AppStrings.markAiModifiedDesc,
                      _p.dimodifikasiAi,
                      (v) => setState(() => _p.dimodifikasiAi = v),
                    ),
                    const SizedBox(height: 14),
                    _barisSwitch(
                      AppStrings.showAiPeople,
                      AppStrings.showAiPeopleDesc,
                      _p.orangBuatanAi,
                      (v) => setState(() => _p.orangBuatanAi = v),
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

  Widget _judulBagian(String teks) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          teks,
          style: const TextStyle(fontSize: 12.5, color: AppColors.teksSekunder),
        ),
      );

  Widget _barisSwitch(
    String judul,
    String? keterangan,
    bool nilai,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              if (keterangan != null) ...[
                const SizedBox(height: 2),
                Text(
                  keterangan,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        SwitchPin(nilai: nilai, onChanged: onChanged),
      ],
    );
  }
}
