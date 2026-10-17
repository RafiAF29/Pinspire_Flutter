import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';

/// Baris "Undang teman-teman Anda" (ikon orang + teks), dipakai di
/// Kotak Masuk dan di halaman Pesan.
class BarisUndang extends StatelessWidget {
  const BarisUndang({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.chipGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person_add_alt,
                size: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.inviteFriends,
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 1),
                  Text(
                    AppStrings.inviteFriendsDesc,
                    style: TextStyle(fontSize: 12.5, color: AppColors.hint),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
