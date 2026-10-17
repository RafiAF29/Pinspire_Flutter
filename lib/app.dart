import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_scroll_behavior.dart';
import 'core/widgets/phone_frame.dart';
import 'features/splash/splash_page.dart';

class PinspireApp extends StatelessWidget {
  const PinspireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinspire',
      debugShowCheckedModeBanner: false,
      // Semua tampilan dipaksa mode terang.
      theme: AppTheme.terang,
      darkTheme: AppTheme.terang,
      themeMode: ThemeMode.light,
      scrollBehavior: const AppScrollBehavior(),
      // Di laptop/web, aplikasi dibungkus bingkai ukuran HP Android.
      builder: (context, child) => PhoneFrame(child: child ?? const SizedBox()),
      home: const SplashPage(),
    );
  }
}
