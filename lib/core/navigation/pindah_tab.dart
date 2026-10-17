import 'package:flutter/material.dart';

import '../../features/create/widgets/create_sheet.dart';
import 'tab_state.dart';

/// Dipakai bottom nav di halaman yang dibuka di atas MainShell (hasil
/// pencarian, profil, detail pin): kembali ke MainShell lalu pindah tab.
/// Tombol + (indeks 2) membuka pilihan Pin/Kolase/Papan.
void pindahTab(BuildContext context, int i) {
  final nav = Navigator.of(context);
  nav.popUntil((r) => r.isFirst);
  if (i == 2) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = nav.overlay?.context;
      if (ctx != null && ctx.mounted) showCreateSheet(ctx);
    });
  } else {
    tabIndex.value = i;
  }
}
