import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../data/board_store.dart';
import 'sheet_header.dart';

/// Sheet "Buat papan". Mengembalikan papan yang baru dibuat (atau null).
Future<Board?> showBuatPapanSheet(
  BuildContext context, {
  IconData ikonKiri = Icons.chevron_left,
}) {
  return showModalBottomSheet<Board>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _BuatPapanSheet(ikonKiri: ikonKiri),
  );
}

class _BuatPapanSheet extends StatefulWidget {
  const _BuatPapanSheet({required this.ikonKiri});

  final IconData ikonKiri;

  @override
  State<_BuatPapanSheet> createState() => _BuatPapanSheetState();
}

class _BuatPapanSheetState extends State<_BuatPapanSheet> {
  final _namaC = TextEditingController();
  final _fokus = FocusNode();
  bool _privat = false;

  @override
  void initState() {
    super.initState();
    _namaC.addListener(_ubah);
    _fokus.addListener(_ubah);
  }

  void _ubah() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _namaC.dispose();
    _fokus.dispose();
    super.dispose();
  }

  bool get _siap => _namaC.text.trim().isNotEmpty;

  void _buat() {
    if (!_siap) return;
    final papan =
        BoardStore.instance.buat(_namaC.text.trim(), privat: _privat);
    Navigator.of(context).pop(papan);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final tinggi = math.max(360.0, mq.size.height * 0.93 - mq.viewInsets.bottom);

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: SizedBox(
        height: tinggi,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              SheetHeader(
                title: AppStrings.newBoard,
                icon: widget.ikonKiri,
                onTap: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Center(child: _PratinjauPapan()),
                      const SizedBox(height: 22),
                      _kolomNama(),
                      const SizedBox(height: 14),
                      _barisSwitch(),
                      const SizedBox(height: 16),
                      _barisKelompok(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: GestureDetector(
                  onTap: _buat,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _siap ? AppColors.red : AppColors.chipGrey,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      AppStrings.newBoard,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _siap ? Colors.white : const Color(0xFF9A9A92),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kolomNama() {
    final fokus = _fokus.hasFocus;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: fokus ? Colors.black : AppColors.outline,
          width: fokus ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.boardName,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                TextField(
                  controller: _namaC,
                  focusNode: _fokus,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  cursorColor: Colors.red,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 4),
                    hintText: AppStrings.boardNameHint,
                    hintStyle: TextStyle(fontSize: 14, color: AppColors.hint),
                  ),
                ),
              ],
            ),
          ),
          if (fokus && _namaC.text.isNotEmpty)
            GestureDetector(
              onTap: _namaC.clear,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.cancel_outlined, size: 22, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }

  Widget _barisSwitch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.boardPrivate,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2),
              Text(
                AppStrings.boardPrivateDesc,
                style: TextStyle(fontSize: 11, height: 1.25, color: Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: _privat,
          onChanged: (v) => setState(() => _privat = v),
          thumbColor: WidgetStateProperty.resolveWith<Color?>(
            (s) => s.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFF76766B),
          ),
          trackColor: WidgetStateProperty.resolveWith<Color?>(
            (s) => s.contains(WidgetState.selected)
                ? const Color(0xFF4355DB)
                : AppColors.chipGrey,
          ),
          trackOutlineColor:
              const WidgetStatePropertyAll<Color>(Colors.transparent),
        ),
      ],
    );
  }

  Widget _barisKelompok() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.groupBoard,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2),
              Text(
                AppStrings.groupBoardDesc,
                style: TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ],
          ),
        ),
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: AppColors.chipGrey,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_add_alt_1_outlined,
              size: 18, color: Colors.black),
        ),
      ],
    );
  }
}

/// Kotak abu-abu pengganti sampul papan (satu besar + dua kecil).
class _PratinjauPapan extends StatelessWidget {
  const _PratinjauPapan();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 152,
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            const Expanded(
              flex: 2,
              child: ColoredBox(
                color: AppColors.chipGrey,
                child: SizedBox.expand(),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Column(
                children: const [
                  Expanded(
                    child: ColoredBox(
                      color: AppColors.chipGrey,
                      child: SizedBox.expand(),
                    ),
                  ),
                  SizedBox(height: 2),
                  Expanded(
                    child: ColoredBox(
                      color: AppColors.chipGrey,
                      child: SizedBox.expand(),
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
