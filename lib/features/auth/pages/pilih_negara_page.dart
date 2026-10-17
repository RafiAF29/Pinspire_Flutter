import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/daftar_negara.dart';

/// Daftar negara/wilayah. Mengembalikan nama negara yang dipilih lewat pop.
class PilihNegaraPage extends StatelessWidget {
  const PilihNegaraPage({super.key, required this.terpilih});

  final String terpilih;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left, size: 34),
                  ),
                  const Text(
                    'Negara/wilayah',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: daftarNegara.length,
                itemBuilder: (context, i) {
                  final negara = daftarNegara[i];
                  final dipilih = negara == terpilih;
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(negara),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              negara,
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.teks,
                                fontWeight:
                                    dipilih ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (dipilih)
                            const Icon(Icons.check, size: 22, color: AppColors.teks),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
