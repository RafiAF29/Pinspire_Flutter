import 'package:flutter/material.dart';

/// Judul sheet: ikon di kiri (X atau panah kembali) + teks tebal di tengah.
class SheetHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const SheetHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(icon, size: 26, color: Colors.black),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
