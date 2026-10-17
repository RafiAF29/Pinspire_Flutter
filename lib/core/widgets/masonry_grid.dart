import 'package:flutter/material.dart';

/// Grid gaya Pinterest: item dimasukkan ke kolom yang paling pendek,
/// jadi tinggi tiap item boleh beda-beda (sesuai rasio gambarnya).
class MasonryGrid<T> extends StatelessWidget {
  final List<T> items;
  final int columns;
  final double crossSpacing; // jarak antar kolom
  final double mainSpacing; // jarak antar item dalam kolom

  /// Tinggi tambahan per item (dalam satuan "lebar item"), mis. untuk baris judul.
  /// Hanya dipakai untuk memperkirakan kolom mana yang paling pendek.
  final double extraRatio;

  final double Function(T item) aspectOf; // lebar / tinggi
  final Widget Function(BuildContext context, T item) itemBuilder;

  const MasonryGrid({
    super.key,
    required this.items,
    required this.columns,
    required this.aspectOf,
    required this.itemBuilder,
    this.crossSpacing = 6,
    this.mainSpacing = 6,
    this.extraRatio = 0,
  });

  @override
  Widget build(BuildContext context) {
    final cols = List.generate(columns, (_) => <T>[]);
    final heights = List<double>.filled(columns, 0);

    for (final item in items) {
      var target = 0;
      for (var i = 1; i < columns; i++) {
        if (heights[i] < heights[target]) target = i;
      }
      cols[target].add(item);
      heights[target] += 1 / aspectOf(item) + extraRatio;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < columns; i++) ...[
          if (i > 0) SizedBox(width: crossSpacing),
          Expanded(
            child: Column(
              children: [
                for (final item in cols[i])
                  Padding(
                    padding: EdgeInsets.only(bottom: mainSpacing),
                    child: itemBuilder(context, item),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
