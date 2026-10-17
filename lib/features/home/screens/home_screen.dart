import 'package:flutter/material.dart';

import '../../pin/data/pin_repository.dart';
import '../../pin/models/pin.dart';
import '../../pin/widgets/pin_card.dart';

/// Layar 1: feed 2 kolom.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PinRepository.instance;
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _column(repo.homeLeftColumn())),
            const SizedBox(width: 6),
            Expanded(child: _column(repo.homeRightColumn())),
          ],
        ),
      ),
    );
  }

  Widget _column(List<Pin> pins) =>
      Column(children: [for (final p in pins) PinCard(pin: p)]);
}
