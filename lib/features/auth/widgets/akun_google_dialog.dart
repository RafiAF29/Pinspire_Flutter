import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pinspire_logo.dart';
import '../models/data_registrasi.dart';

/// Akun contoh pada dialog "Pilih akun". Ubah sesuai kebutuhan demo.
const List<AkunGoogle> _akunContoh = [
  AkunGoogle(nama: 'Rina Putri', email: 'rina.putri@gmail.com'),
  AkunGoogle(nama: 'Dimas Pratama', email: 'dimas.pratama@gmail.com'),
  AkunGoogle(nama: 'Salsa Nabila', email: 'salsa.nabila@gmail.com'),
];

const List<Color> _warnaAvatar = [
  Color(0xFF5E35B1),
  Color(0xFFF4511E),
  Color(0xFF8E24AA),
  Color(0xFF6D4C41),
];

/// Dialog "Pilih akun" ala Google. Mengembalikan akun yang dipilih (atau null).
Future<AkunGoogle?> tampilkanAkunGoogleDialog(BuildContext context) {
  return showDialog<AkunGoogle>(
    context: context,
    builder: (_) => const _AkunGoogleDialog(),
  );
}

class _AkunGoogleDialog extends StatelessWidget {
  const _AkunGoogleDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PinspireLogo(ukuran: 36),
            const SizedBox(height: 16),
            const Text(
              'Pilih akun',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.teks,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'untuk melanjutkan ke Pinspire',
              style: TextStyle(fontSize: 14, color: AppColors.teksSekunder),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < _akunContoh.length; i++)
              _BarisAkun(
                akun: _akunContoh[i],
                warna: _warnaAvatar[i % _warnaAvatar.length],
              ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menambah akun lain belum tersedia di versi demo.'),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                child: Row(
                  children: [
                    Icon(Icons.person_add_alt_outlined,
                        size: 22, color: AppColors.teksSekunder),
                    SizedBox(width: 16),
                    Text(
                      'Tambahkan akun lain',
                      style: TextStyle(fontSize: 15, color: AppColors.teks),
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
}

class _BarisAkun extends StatelessWidget {
  const _BarisAkun({required this.akun, required this.warna});

  final AkunGoogle akun;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(akun),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: warna,
              child: Text(
                akun.nama.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    akun.nama,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teks,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    akun.email,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.teksSekunder,
                    ),
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
