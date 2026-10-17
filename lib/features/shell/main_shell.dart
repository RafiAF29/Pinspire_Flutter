import 'package:flutter/material.dart';

import '../../core/navigation/tab_state.dart';
import '../../core/strings.dart';
import '../../core/widgets/bottom_nav.dart';
import '../create/widgets/create_sheet.dart';
import '../create/widgets/publish_overlay.dart';
import '../home/screens/home_screen.dart';
import '../inbox/screens/inbox_screen.dart';
import '../search/screens/search_screen.dart';
import '../saved/screens/saved_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tabIndex,
      builder: (context, index, _) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: IndexedStack(
                  index: index,
                  children: const [
                    HomeScreen(),
                    SearchScreen(),
                    _ComingSoon(AppStrings.navCreate),
                    InboxScreen(),
                    SavedScreen(),
                  ],
                ),
              ),
              // Bar "Menyelesaikan ..." / toast "Diterbitkan!" di atas bottom nav.
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: PublishOverlay(),
              ),
            ],
          ),
          bottomNavigationBar: PinBottomNav(
            index: index,
            onTap: (i) {
              // Tombol + (Buat) membuka pilihan, bukan pindah tab.
              if (i == 2) {
                showCreateSheet(context);
              } else {
                tabIndex.value = i;
              }
            },
          ),
        );
      },
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String label;
  const _ComingSoon(this.label);

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(label, style: const TextStyle(fontSize: 16)));
}
