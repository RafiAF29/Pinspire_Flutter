import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/header_halaman.dart';
import '../../../core/widgets/kolom_berlabel.dart';
import '../../../core/widgets/switch_pin.dart';
import '../data/profil_store.dart';
import 'tentang_page.dart';

/// Sheet "Edit profil" (naik dari bawah, seperti di aplikasi asli).
Future<void> tampilkanEditProfil(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => const _EditProfilSheet(),
  );
}

class _EditProfilSheet extends StatefulWidget {
  const _EditProfilSheet();

  @override
  State<_EditProfilSheet> createState() => _EditProfilSheetState();
}

class _EditProfilSheetState extends State<_EditProfilSheet> {
  static const int _maksNama = 65;

  final DataProfil _awal = ProfilStore.instance.saatIni;
  late final TextEditingController _namaC = TextEditingController(text: _awal.nama);
  late final TextEditingController _userC =
      TextEditingController(text: _awal.namaPengguna);
  late final TextEditingController _situsC = TextEditingController(text: _awal.situs);
  late String _bio = _awal.bio;
  late bool _semuaPin = _awal.tampilkanSemuaPin;

  @override
  void initState() {
    super.initState();
    for (final c in [_namaC, _userC, _situsC]) {
      c.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _namaC.dispose();
    _userC.dispose();
    _situsC.dispose();
    super.dispose();
  }

  bool get _berubah =>
      _namaC.text.trim() != _awal.nama ||
      _userC.text.trim() != _awal.namaPengguna ||
      _situsC.text.trim() != _awal.situs ||
      _bio.trim() != _awal.bio ||
      _semuaPin != _awal.tampilkanSemuaPin;

  bool get _siap =>
      _berubah && _namaC.text.trim().isNotEmpty && _userC.text.trim().isNotEmpty;

  void _selesai() {
    ProfilStore.instance.simpan(
      nama: _namaC.text,
      namaPengguna: _userC.text,
      bio: _bio,
      situs: _situsC.text,
      tampilkanSemuaPin: _semuaPin,
    );
    Navigator.of(context).pop();
  }

  Future<void> _ubahTentang() async {
    FocusScope.of(context).unfocus();
    final hasil = await bukaTentang(context, _bio);
    if (hasil != null && mounted) setState(() => _bio = hasil);
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: FractionallySizedBox(
        heightFactor: 0.95,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 6),
              HeaderHalaman(
                judul: AppStrings.editProfile,
                onKiri: () => Navigator.of(context).pop(),
                kanan: TombolPil(
                  label: AppStrings.done,
                  aktif: _siap,
                  onTap: _selesai,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.profilePrivacy,
                        style: TextStyle(fontSize: 15, height: 1.3),
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 54,
                              backgroundColor: const Color(0xFFDEE0FC),
                              child: Text(
                                _namaC.text.trim().isEmpty
                                    ? _awal.inisial
                                    : _namaC.text.trim()[0].toUpperCase(),
                                style: const TextStyle(fontSize: 46, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.chipGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // widthFactor: 1 -> tombol selebar teks saja.
                              child: const Center(
                                widthFactor: 1,
                                child: Text(
                                  AppStrings.edit,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      KolomBerlabel(
                        label: AppStrings.name,
                        controller: _namaC,
                        maxChar: _maksNama,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 4, 16, 14),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_namaC.text.length}/$_maksNama',
                            style: const TextStyle(fontSize: 10.5, color: AppColors.hint),
                          ),
                        ),
                      ),
                      KolomBerlabel(
                        label: AppStrings.username,
                        controller: _userC,
                        maxChar: 30,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _ubahTentang,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 20, 0, 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.about,
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      _bio.isEmpty ? AppStrings.aboutHint : _bio,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.teksSekunder,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, size: 24, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                      KolomBerlabel(
                        label: AppStrings.website,
                        hint: AppStrings.websiteHint,
                        controller: _situsC,
                        maxBaris: 2,
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        AppStrings.layout,
                        style: TextStyle(fontSize: 14, color: AppColors.teksSekunder),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.showAllPins,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  AppStrings.showAllPinsDesc,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.3,
                                    color: AppColors.teksSekunder,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SwitchPin(
                            nilai: _semuaPin,
                            onChanged: (v) => setState(() => _semuaPin = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
