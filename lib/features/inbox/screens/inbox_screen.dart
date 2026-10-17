import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../pages/pesan_page.dart';
import '../widgets/baris_undang.dart';
import '../widgets/ilustrasi_botol.dart';
import '../widgets/undang_teman_sheet.dart';

/// Tab Kotak Masuk (tampilan 1).
/// - "Undang teman-teman Anda" -> sheet bagikan tautan profil (tampilan 2).
/// - "Lihat semua"             -> halaman Pesan (tampilan 3).
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  void _bukaPesan(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PesanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Row(
              children: [
                const Text(
                  AppStrings.inboxTitle,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => tampilkanUndangTeman(context),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Text(
                  AppStrings.messages,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _bukaPesan(context),
                  child: const Row(
                    children: [
                      Text(
                        AppStrings.seeAll,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right, size: 22, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: BarisUndang(onTap: () => tampilkanUndangTeman(context)),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              AppStrings.updates,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(36, 36, 36, 24),
              child: const Column(
                children: [
                  IlustrasiBotol(ukuran: 140),
                  SizedBox(height: 22),
                  Text(
                    AppStrings.updatesDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
