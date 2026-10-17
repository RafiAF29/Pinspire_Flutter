import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme/app_colors.dart';

class PinBottomNav extends StatelessWidget {
  final ValueChanged<int> onTap;

  /// Tab yang sedang aktif (ikonnya tampil tebal/terisi): 0 Beranda, 1 Cari,
  /// 3 Kotak Masuk, 4 Disimpan. Tombol + (2) tidak pernah aktif.
  final int index;

  const PinBottomNav({super.key, required this.onTap, this.index = 0});

  // (ikon tidak aktif, ikon aktif, label)
  static const _items = <(IconData, IconData, String)>[
    (Icons.home_outlined, Icons.home_filled, AppStrings.navHome),
    (Icons.search, Icons.search, AppStrings.navSearch),
    (Icons.add, Icons.add, AppStrings.navCreate),
    (Icons.chat_bubble_outline, Icons.chat_bubble, AppStrings.navInbox),
    (Icons.person_outline, Icons.person, AppStrings.navSaved),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.navBorder)),
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 6,
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final (ikon, ikonAktif, label) = _items[i];
          final aktif = i == index && i != 2;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    aktif ? ikonAktif : ikon,
                    size: 26,
                    color: Colors.black,
                    // Kaca pembesar tidak punya versi "terisi", jadi
                    // ditebalkan dengan bayangan tipis tanpa blur.
                    shadows: aktif && i == 1
                        ? const [
                            Shadow(color: Colors.black, offset: Offset(0.7, 0)),
                            Shadow(color: Colors.black, offset: Offset(0, 0.7)),
                          ]
                        : null,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: aktif ? FontWeight.w800 : FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
