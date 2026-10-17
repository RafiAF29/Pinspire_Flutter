import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pinterest1/app.dart';
import 'package:pinterest1/core/navigation/tab_state.dart';
import 'package:pinterest1/core/theme/app_theme.dart';
import 'package:pinterest1/features/create/data/gallery_access_store.dart';
import 'package:pinterest1/features/create/data/publish_store.dart';
import 'package:pinterest1/features/pin/data/saved_store.dart';
import 'package:pinterest1/features/pin/widgets/pin_card.dart';
import 'package:pinterest1/features/pin_detail/widgets/save_button.dart';
import 'package:pinterest1/features/shell/main_shell.dart';

/// Teks di dalam tombol Simpan/Disimpan/Profil
/// (dipisah dari label bottom nav yang juga bertuliskan "Disimpan").
Finder inSaveButton(String text) =>
    find.descendant(of: find.byType(SaveButton), matching: find.text(text));

/// Membuka langsung Beranda (setelah splash & login dilewati).
Future<void> bukaBeranda(WidgetTester tester) => tester.pumpWidget(
      MaterialApp(theme: AppTheme.terang, home: const MainShell()),
    );

void main() {
  setUp(() {
    tabIndex.value = 0;
    GalleryAccessStore.instance.reset();
  });

  testWidgets('Splash tampil lalu pindah ke halaman awal Pinspire',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PinspireApp());

    // Splash menunggu sekitar 2,2 detik sebelum pindah halaman.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Lanjutkan'), findsOneWidget);
    expect(find.text('Lanjutkan dengan Google'), findsOneWidget);
  });

  testWidgets('Beranda terbuka di tab Beranda', (WidgetTester tester) async {
    await bukaBeranda(tester);
    expect(find.text('Beranda'), findsOneWidget);
  });

  testWidgets('Flow like: outline -> merah + label Suka + 153 jadi 154',
      (WidgetTester tester) async {
    await bukaBeranda(tester);

    // Buka detail pin pertama (153 like, 3 komentar).
    await tester.tap(find.byType(PinCard).first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.text('153'), findsOneWidget);
    expect(find.text('Suka'), findsNothing);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('154'), findsOneWidget);
    expect(find.text('Suka'), findsOneWidget);

    // Label hilang sendiri, hati & angka tetap.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Suka'), findsNothing);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('154'), findsOneWidget);

    // Tap lagi = unlike.
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.text('153'), findsOneWidget);
  });

  testWidgets(
      'Flow simpan: Simpan -> Disimpan -> Profil -> tab Disimpan -> hapus',
      (WidgetTester tester) async {
    await bukaBeranda(tester);

    // Buka detail pin pertama.
    await tester.tap(find.byType(PinCard).first);
    await tester.pumpAndSettle();

    // Belum disimpan: tombol "Simpan", belum ada bottom nav.
    expect(inSaveButton('Simpan'), findsOneWidget);
    expect(find.text('Beranda'), findsNothing);

    // Tap Simpan -> "Disimpan" + bottom nav muncul.
    await tester.tap(inSaveButton('Simpan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(inSaveButton('Disimpan'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);

    // Otomatis berubah jadi "Profil".
    await tester.pump(SavedStore.justSavedDuration);
    await tester.pumpAndSettle();
    expect(inSaveButton('Profil'), findsOneWidget);

    // Tap Profil -> pindah ke tab Disimpan, ada 1 pin.
    await tester.tap(inSaveButton('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('1 Pin disimpan'), findsOneWidget);

    // Batal simpan: tekan lama pin -> "Hapus dari Disimpan".
    await tester.longPress(find.byKey(const ValueKey('saved-dog')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus dari Disimpan'));
    await tester.pumpAndSettle();
    expect(find.text('0 Pin disimpan'), findsOneWidget);
  });

  testWidgets('Galeri: bisa pilih banyak, badge bernomor, banner & strip',
      (WidgetTester tester) async {
    GalleryAccessStore.instance.izinkanSemua();
    await bukaBeranda(tester);
    await tester.tap(find.text('Buat'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text('Pin'),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('galeri-foto_01')));
    await tester.pump();
    expect(find.text('Beberapa aset akan membuat satu video'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('galeri-foto_02')));
    await tester.pump();
    expect(find.text('Beberapa aset akan membuat satu video'),
        findsOneWidget);
    expect(find.byKey(const ValueKey('terpilih-foto_01')), findsOneWidget);
    expect(find.byKey(const ValueKey('terpilih-foto_02')), findsOneWidget);

    // Batalkan pilihan pertama -> foto_02 jadi nomor 1, banner hilang.
    await tester.tap(find.byKey(const ValueKey('galeri-foto_01')));
    await tester.pump();
    expect(find.byKey(const ValueKey('terpilih-foto_01')), findsNothing);
    expect(find.text('Beberapa aset akan membuat satu video'), findsNothing);
  });

  testWidgets('Ikon kamera di galeri membuka layar kamera',
      (WidgetTester tester) async {
    GalleryAccessStore.instance.izinkanSemua();
    await bukaBeranda(tester);
    await tester.tap(find.text('Buat'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text('Pin'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.photo_camera_outlined));
    await tester.pumpAndSettle();

    // Plugin kamera tidak ada di lingkungan tes -> layar "Gunakan kamera
    // Anda" + tombol coba lagi. Di perangkat sungguhan: pratinjau langsung.
    expect(find.text('Gunakan kamera Anda'), findsOneWidget);
    expect(find.text('Coba lagi'), findsOneWidget);
  });

  // Letakkan paling akhir: pin yang diterbitkan masuk ke tab Disimpan.
  testWidgets(
      'Flow Buat Pin: Buat -> Pin -> izin -> galeri -> form -> unggah -> terbit',
      (WidgetTester tester) async {
    await bukaBeranda(tester);

    // Tombol + (Buat) -> sheet pilihan.
    await tester.tap(find.text('Buat'));
    await tester.pumpAndSettle();
    expect(find.text('Mulai berkreasi sekarang'), findsOneWidget);

    // Pin -> layar izin + dialog (akun ini belum pernah Allow all).
    await tester.tap(find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text('Pin'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Izinkan akses untuk melanjutkan'), findsOneWidget);
    expect(find.text('Allow all'), findsOneWidget);

    // Allow all -> galeri; "Berikutnya" belum aktif sampai ada yang dipilih.
    await tester.tap(find.text('Allow all'));
    await tester.pumpAndSettle();
    expect(find.text('Semua foto'), findsOneWidget);
    expect(GalleryAccessStore.instance.sudahIzinkanSemua, isTrue);

    await tester.tap(find.byKey(const ValueKey('galeri-foto_01')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Berikutnya'));
    await tester.pumpAndSettle();

    // Formulir Buat Pin.
    expect(find.text('Buat Pin'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Pantai sore');
    await tester.pump();
    expect(find.text('11/100'), findsOneWidget);

    // Buat -> kembali ke Beranda, bar unggah muncul lalu toast terbit.
    await tester.tap(find.text('Buat'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Menyelesaikan ...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Diterbitkan! Ingin berbagi?'), findsOneWidget);
    expect(SavedStore.instance.pins.first.title, 'Pantai sore');

    // Toast hilang sendiri.
    await tester.pump(PublishStore.durasiToast);
    await tester.pumpAndSettle();
    expect(find.text('Diterbitkan! Ingin berbagi?'), findsNothing);
  });
}
