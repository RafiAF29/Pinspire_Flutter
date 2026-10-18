import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Kolom isian bergaya Pinterest: sudut membulat 16, label kecil di atas
/// nilai, garis tebal saat fokus, ikon mata (kata sandi) atau tombol hapus.
class PinTextField extends StatefulWidget {
  const PinTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.togglePassword = false,
    this.tampilkanHapus = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.errorText,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;

  /// Mode kata sandi: teks disamarkan + ikon mata untuk menampilkan.
  final bool togglePassword;

  /// Tampilkan ikon (x) untuk menghapus isi saat fokus.
  final bool tampilkanHapus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? errorText;

  @override
  State<PinTextField> createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  late final FocusNode _fokus = widget.focusNode ?? FocusNode();
  bool _sembunyi = true;

  @override
  void initState() {
    super.initState();
    _fokus.addListener(_ubah);
    widget.controller.addListener(_ubah);
  }

  @override
  void dispose() {
    _fokus.removeListener(_ubah);
    widget.controller.removeListener(_ubah);
    if (widget.focusNode == null) _fokus.dispose();
    super.dispose();
  }

  void _ubah() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final fokus = _fokus.hasFocus;
    final adaError = widget.errorText != null;
    final warnaGaris = adaError
        ? AppColors.merah
        : (fokus ? AppColors.teks : AppColors.garis);

    Widget? akhiran;
    if (widget.togglePassword) {
      akhiran = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _sembunyi = !_sembunyi),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            _sembunyi ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 24,
            color: AppColors.teks,
          ),
        ),
      );
    } else if (widget.tampilkanHapus &&
        fokus &&
        widget.controller.text.isNotEmpty) {
      akhiran = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.controller.clear();
          widget.onChanged?.call('');
        },
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.cancel_outlined, size: 24, color: AppColors.teks),
        ),
      );
    }

    final password = widget.togglePassword;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: warnaGaris,
              width: (fokus || adaError) ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.label != null)
                      Text(
                        widget.label!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teks,
                        ),
                      ),
                    TextField(
                      controller: widget.controller,
                      focusNode: _fokus,
                      autofocus: widget.autofocus,
                      obscureText: password && _sembunyi,
                      autocorrect: !password,
                      enableSuggestions: !password,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      cursorColor: AppColors.teks,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.teks,
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 6),
                      ).copyWith(
                        hintText: widget.hint,
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: AppColors.teksHint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ?akhiran,
            ],
          ),
        ),
        if (adaError)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(fontSize: 13, color: AppColors.merah),
            ),
          ),
      ],
    );
  }
}
