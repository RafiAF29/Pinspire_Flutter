import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Kolom isian dengan label kecil di dalam kotak (gaya Pinterest).
/// Garis pinggir menebal & hitam saat fokus.
class KolomBerlabel extends StatefulWidget {
  const KolomBerlabel({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.maxChar,
    this.maxBaris = 1,
    this.onChanged,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int? maxChar;
  final int maxBaris;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  State<KolomBerlabel> createState() => _KolomBerlabelState();
}

class _KolomBerlabelState extends State<KolomBerlabel> {
  final FocusNode _fokus = FocusNode();

  @override
  void initState() {
    super.initState();
    _fokus.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _fokus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fokus = _fokus.hasFocus;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: fokus ? Colors.black : AppColors.outline,
          width: fokus ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          TextField(
            controller: widget.controller,
            focusNode: _fokus,
            minLines: 1,
            maxLines: widget.maxBaris,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            inputFormatters: [
              if (widget.maxChar != null)
                LengthLimitingTextInputFormatter(widget.maxChar),
            ],
            style: const TextStyle(fontSize: 14.5, color: Colors.black),
            cursorColor: Colors.red,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 4),
              hintText: widget.hint,
              hintStyle: const TextStyle(fontSize: 14.5, color: AppColors.hint),
            ),
          ),
        ],
      ),
    );
  }
}
