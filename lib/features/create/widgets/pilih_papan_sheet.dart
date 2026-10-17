import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../data/board_store.dart';
import 'sheet_header.dart';

/// Hasil sheet "Simpan ke papan": papan yang dipilih, atau minta buat baru.
class PilihPapanHasil {
  final Board? papan;
  final bool buatBaru;
  const PilihPapanHasil.papan(Board this.papan) : buatBaru = false;
  const PilihPapanHasil.baru()
      : papan = null,
        buatBaru = true;
}

Future<PilihPapanHasil?> showPilihPapanSheet(
  BuildContext context, {
  Board? terpilih,
}) {
  return showModalBottomSheet<PilihPapanHasil>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      final tinggi = MediaQuery.of(sheetContext).size.height * 0.58;
      return SizedBox(
        height: tinggi,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              SheetHeader(
                title: AppStrings.saveToBoard,
                icon: Icons.close,
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    for (final b in BoardStore.instance.boards)
                      ListTile(
                        key: ValueKey('papan-${b.id}'),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.chipGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        title: Text(
                          b.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: b.privat
                            ? const Icon(Icons.lock_outline,
                                size: 18, color: Colors.black)
                            : null,
                        selected: b.id == terpilih?.id,
                        onTap: () => Navigator.of(sheetContext)
                            .pop(PilihPapanHasil.papan(b)),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(sheetContext)
                    .pop(const PilihPapanHasil.baru()),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.chipGrey,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add,
                            size: 26, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        AppStrings.newBoard,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
