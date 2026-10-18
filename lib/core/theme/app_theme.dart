import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get terang {
    final skema =
        ColorScheme.fromSeed(
          seedColor: AppColors.merah,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.merah,
          onPrimary: Colors.white,
          surface: Colors.white,
        );

    // Transisi geser horizontal ala iOS/Pinterest di semua platform.
    const geser = CupertinoPageTransitionsBuilder();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: skema,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      // Font Inter dari Google Fonts — lebih premium dari font sistem.
      textTheme: GoogleFonts.interTextTheme(
        ThemeData(brightness: Brightness.light).textTheme,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: geser,
          TargetPlatform.iOS: geser,
          TargetPlatform.windows: geser,
          TargetPlatform.linux: geser,
          TargetPlatform.macOS: geser,
        },
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.teks,
        selectionHandleColor: AppColors.teks,
      ),
    );
  }
}

