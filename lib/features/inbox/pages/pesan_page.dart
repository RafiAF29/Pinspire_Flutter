import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../widgets/baris_undang.dart';
import '../widgets/undang_teman_sheet.dart';

/// Halaman "Pesan" (tampilan 3), dibuka dari "Lihat semua" di Kotak Masuk.
/// Berisi daftar kontak; sementara baru ada ajakan mengundang teman.
class PesanPage extends StatelessWidget {
  const PesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.chevron_left, size: 32, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    AppStrings.messages,
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
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                AppStrings.contacts,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: BarisUndang(onTap: () => tampilkanUndangTeman(context)),
            ),
          ],
        ),
      ),
    );
  }
}
