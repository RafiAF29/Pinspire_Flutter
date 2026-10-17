import 'package:flutter/foundation.dart';

/// Index tab bottom nav yang aktif:
/// 0 Home, 1 Search, 2 Create, 3 Inbox, 4 Saved.
/// Dipakai MainShell dan juga halaman detail (untuk pindah tab).
final ValueNotifier<int> tabIndex = ValueNotifier<int>(0);
