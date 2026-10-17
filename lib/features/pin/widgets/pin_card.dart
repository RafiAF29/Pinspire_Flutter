import 'package:flutter/material.dart';

import '../../../core/widgets/pin_image.dart';
import '../../pin_detail/screens/pin_detail_screen.dart';
import '../models/pin.dart';

/// Kartu pin: gambar + judul + titik tiga (dipakai di Home dan "More to explore").
class PinCard extends StatelessWidget {
  final Pin pin;
  final bool openDetail;
  const PinCard({super.key, required this.pin, this.openDetail = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openDetail
          ? () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PinDetailScreen(pin: pin)),
              )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: pin.aspect,
              child: PinImage(pin),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 12, left: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    pin.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                const Icon(Icons.more_horiz, size: 18, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
